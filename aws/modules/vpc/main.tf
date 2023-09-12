locals {
  az1 = "${var.aws_region}a"
  az2 = "${var.aws_region}b"
  az3 = "${var.aws_region}c"
}

### VPC ###
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${var.workload}"
  }
}

### Internet Gateway ###
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ig-${var.workload}"
  }
}

### Subnets ###
module "data_subnets" {
  source   = "./subnets/data"
  vpc_id   = aws_vpc.main.id
  workload = var.workload

  az1 = local.az1
  az2 = local.az2
  az3 = local.az3
}

module "application_subnets" {
  source              = "./subnets/application"
  vpc_id              = aws_vpc.main.id
  interget_gateway_id = aws_internet_gateway.main.id
  workload            = var.workload

  az1 = local.az1
  az2 = local.az2
  az3 = local.az3
}

module "balancer_subnets" {
  source              = "./subnets/balancer"
  vpc_id              = aws_vpc.main.id
  interget_gateway_id = aws_internet_gateway.main.id
  workload            = var.workload

  az1 = local.az1
  az2 = local.az2
  az3 = local.az3
}
