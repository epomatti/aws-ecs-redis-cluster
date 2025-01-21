locals {
  port = 6379
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id = "cluster-${var.workload}"
  description          = "Application Cache"

  engine               = var.engine
  engine_version       = var.engine_version
  parameter_group_name = var.parameter_group
  auth_token           = var.auth_token

  node_type          = var.node_type
  num_cache_clusters = var.num_cache_clusters
  port               = local.port

  auto_minor_version_upgrade = true
  automatic_failover_enabled = true
  apply_immediately          = true
  multi_az_enabled           = true

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  subnet_group_name  = aws_elasticache_subnet_group.main.name
  security_group_ids = [aws_security_group.default.id]
}

### Network ###

resource "aws_elasticache_subnet_group" "main" {
  name       = "cache-${var.workload}"
  subnet_ids = var.subnets
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "default" {
  name        = "cache-${var.workload}"
  description = "Inbound for ElastiCache"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-cache-${var.workload}"
  }
}

resource "aws_security_group_rule" "ingress_elasticache" {
  description       = "Allows ElastiCache ingress"
  type              = "ingress"
  from_port         = local.port
  to_port           = local.port
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  security_group_id = aws_security_group.default.id
}
