terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}

module "vpc" {
  source     = "./modules/vpc"
  aws_region = var.aws_region
  workload   = var.workload
}

module "cache" {
  source             = "./modules/cache"
  workload           = var.workload
  subnets            = module.vpc.data_subnets
  vpc_id             = module.vpc.vpc_id
  engine             = var.elasticache_engine
  engine_version     = var.elasticache_engine_version
  parameter_group    = var.elasticache_parameter_group
  node_type          = var.elasticache_node_type
  num_cache_clusters = var.elasticache_num_cache_clusters
  auth_token         = var.elasticache_auth_token
}

module "elb" {
  source   = "./modules/elb"
  workload = var.workload
  subnets  = module.vpc.elb_subnets
  vpc_id   = module.vpc.vpc_id
}

module "secrets" {
  source                  = "./modules/sm"
  workload                = var.workload
  recovery_window_in_days = var.sm_recovery_window_in_days
}

module "iam_ecs" {
  source                          = "./modules/iam/ecs"
  workload                        = var.workload
  private_key_secret_arn          = module.secrets.private_key_secret_arn
  private_key_password_secret_arn = module.secrets.private_key_password_secret_arn
}

module "iam_ec2" {
  source                          = "./modules/iam/ec2"
  workload                        = var.workload
  private_key_secret_arn          = module.secrets.private_key_secret_arn
  private_key_password_secret_arn = module.secrets.private_key_password_secret_arn
}

module "ecr" {
  source   = "./modules/ecr"
  workload = var.workload
}

module "ecs" {
  source                          = "./modules/ecs"
  workload                        = var.workload
  subnets                         = module.vpc.application_subnets
  vpc_id                          = module.vpc.vpc_id
  aws_region                      = var.aws_region
  ecr_repository_url              = module.ecr.repository_url
  ecs_task_execution_role_arn     = module.iam_ecs.ecs_task_execution_role_arn
  ecs_task_role_arn               = module.iam_ecs.ecs_task_role_arn
  primary_elasticache_endpoint    = module.cache.primary_elasticache_endpoint
  elasticache_port                = module.cache.elasticache_port
  elasticache_auth_token          = var.elasticache_auth_token
  target_group_arn                = module.elb.target_group_arn
  task_cpu                        = var.ecs_task_cpu
  task_memory                     = var.ecs_task_memory
  private_key_secret_arn          = module.secrets.private_key_secret_arn
  private_key_password_secret_arn = module.secrets.private_key_password_secret_arn
  deploy_service                  = var.ecs_deploy_service
}

module "ec2_instance" {
  source                  = "./modules/ec2"
  workload                = var.workload
  vpc_id                  = module.vpc.vpc_id
  subnet_id               = module.vpc.admin_subnet_id
  ami                     = var.ec2_admin_ami
  instance_type           = var.ec2_admin_instance_type
  az                      = module.vpc.azs[0]
  iam_instance_profile_id = module.iam_ec2.iam_instance_profile_id
}
