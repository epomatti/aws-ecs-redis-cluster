output "primary_elasticache_endpoint" {
  value = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "elasticache_port" {
  value = aws_elasticache_replication_group.main.port
}
