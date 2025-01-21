# Project
workload   = "demo"
aws_region = "us-east-2"

# ElastiCache
elasticache_engine             = "redis"
elasticache_engine_version     = "7.1"
elasticache_parameter_group    = "default.redis7"
elasticache_node_type          = "cache.t4g.medium"
elasticache_num_cache_clusters = 2
elasticache_auth_token         = "cxk23fax324fsc1sdf23fxa123535"

# ECS
ecs_deploy_service = false
ecs_task_cpu       = 1024
ecs_task_memory    = 2048

# Secrets Manager
sm_recovery_window_in_days = 0

# EC2
ec2_admin_ami           = "ami-0ac5d9e789dbb455a"
ec2_admin_instance_type = "t4g.small"
