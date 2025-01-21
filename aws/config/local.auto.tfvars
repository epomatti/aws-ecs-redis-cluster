aws_region = "us-east-2"

redis_node_type          = "cache.t4g.medium"
redis_num_cache_clusters = 3
redis_auth_token         = "cxk23fax324fsc1sdf23fxa123535"

ecs_task_cpu    = 1024
ecs_task_memory = 2048

sm_recovery_window_in_days = 0

ec2_admin_ami           = "ami-0ac5d9e789dbb455a"
ec2_admin_instance_type = "t4g.small"
