locals {
  port = 6379
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id = "redis-cluster-${var.workload}"
  description          = "Redis Cache"

  engine               = "redis"
  engine_version       = "7.0"
  parameter_group_name = "default.redis7"
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
  security_group_ids = [aws_security_group.redis.id]
}

### Network ###

resource "aws_elasticache_subnet_group" "main" {
  name       = "redis-${var.workload}"
  subnet_ids = var.subnets
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "redis" {
  name        = "redis-${var.workload}"
  description = "Inbound for Redis"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-redis-${var.workload}"
  }
}

resource "aws_security_group_rule" "ingress_redis" {
  description       = "Allows Redis ingress"
  type              = "ingress"
  from_port         = local.port
  to_port           = local.port
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  security_group_id = aws_security_group.redis.id
}
