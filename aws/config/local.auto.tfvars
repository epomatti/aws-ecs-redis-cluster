aws_region = "us-east-2"

redis_node_type          = "cache.t4g.medium"
redis_num_cache_clusters = 3
redis_auth_token         = "cxk23fax324fsc1sdf23fxa123535"

ecs_task_cpu    = 512
ecs_task_memory = 1024

sm_recovery_window_in_days = 0

ec2_admin_ami           = "ami-036841078a4b68e14"
ec2_admin_instance_type = "t3.medium"
