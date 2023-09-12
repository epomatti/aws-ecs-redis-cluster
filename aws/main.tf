terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
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

module "iam" {
  source   = "./modules/iam"
  workload = local.workload
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
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam.ecs_task_role_arn
  primary_redis_endpoint      = module.redis.primary_redis_endpoint
  redis_port                  = module.redis.redis_port
  redis_auth_token            = var.redis_auth_token
  target_group_arn            = module.elb.target_group_arn
  task_cpu                    = var.ecs_task_cpu
  task_memory                 = var.ecs_task_memory
}
