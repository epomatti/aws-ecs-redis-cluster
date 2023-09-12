output "primary_redis_endpoint_uri" {
  value = "rediss://${aws_elasticache_replication_group.main.primary_endpoint_address}:${aws_elasticache_replication_group.main.port}"
}

output "redis_port" {
  value = aws_elasticache_replication_group.main.port
}
