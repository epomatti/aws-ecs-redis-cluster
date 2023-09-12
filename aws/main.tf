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
  subnets  = module.vpc.data_subnets
  vpc_id   = module.vpc.vpc_id
}

module "iam" {
  source   = "./modules/iam"
  workload = local.workload
}

