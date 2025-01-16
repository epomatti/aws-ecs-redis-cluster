terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.83.1"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "ECS Redis Sandbox"
    }
  }
}

locals {
  workload = "supercache"
}

module "vpc" {
  source     = "./modules/vpc"
  aws_region = var.aws_region
  workload   = local.workload
}

module "redis" {
  source             = "./modules/redis"
  workload           = local.workload
  node_type          = var.redis_node_type
  num_cache_clusters = var.redis_num_cache_clusters
  subnets            = module.vpc.data_subnets
  vpc_id             = module.vpc.vpc_id
  auth_token         = var.redis_auth_token
}

module "elb" {
  source   = "./modules/elb"
  workload = local.workload
  subnets  = module.vpc.elb_subnets
  vpc_id   = module.vpc.vpc_id
}

module "secrets" {
  source                  = "./modules/sm"
  workload                = local.workload
  recovery_window_in_days = var.sm_recovery_window_in_days
}

module "iam_ecs" {
  source                 = "./modules/iam/ecs"
  workload               = local.workload
  private_key_secret_arn = module.secrets.private_key_secret_arn
}

module "iam_ec2" {
  source                 = "./modules/iam/ec2"
  workload               = local.workload
  private_key_secret_arn = module.secrets.private_key_secret_arn
}

module "ecr" {
  source   = "./modules/ecr"
  workload = local.workload
}

module "ecs" {
  source                      = "./modules/ecs"
  workload                    = local.workload
  subnets                     = module.vpc.application_subnets
  vpc_id                      = module.vpc.vpc_id
  aws_region                  = var.aws_region
  ecr_repository_url          = module.ecr.repository_url
  ecs_task_execution_role_arn = module.iam_ecs.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam_ecs.ecs_task_role_arn
  primary_redis_endpoint      = module.redis.primary_redis_endpoint
  redis_port                  = module.redis.redis_port
  redis_auth_token            = var.redis_auth_token
  target_group_arn            = module.elb.target_group_arn
  task_cpu                    = var.ecs_task_cpu
  task_memory                 = var.ecs_task_memory
  private_key_secret_arn      = module.secrets.private_key_secret_arn
}

module "ec2_instance" {
  source                  = "./modules/ec2"
  workload                = local.workload
  vpc_id                  = module.vpc.vpc_id
  subnet_id               = module.vpc.admin_subnet_id
  ami                     = var.ec2_admin_ami
  instance_type           = var.ec2_admin_instance_type
  az                      = module.vpc.azs[0]
  iam_instance_profile_id = module.iam_ec2.iam_instance_profile_id
}
