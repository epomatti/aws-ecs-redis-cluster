variable "workload" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "elasticache_engine" {
  type = string
}

variable "elasticache_engine_version" {
  type = string
}

variable "elasticache_parameter_group" {
  type = string
}

variable "elasticache_node_type" {
  type = string
}

variable "elasticache_num_cache_clusters" {
  type = number
}

variable "elasticache_auth_token" {
  type = string
}

variable "ecs_deploy_service" {
  type = bool
}

variable "ecs_task_cpu" {
  type = number
}

variable "ecs_task_memory" {
  type = number
}

variable "sm_recovery_window_in_days" {
  type = number
}

### EC2 ###
variable "ec2_admin_ami" {
  type = string
}

variable "ec2_admin_instance_type" {
  type = string
}
