variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "redis_node_type" {
  type    = string
  default = "cache.t4g.medium"
}

variable "redis_num_cache_clusters" {
  type    = number
  default = 3
}

variable "redis_auth_token" {
  type      = string
  sensitive = true
}

variable "ecs_task_cpu" {
  type    = number
  default = 512
}

variable "ecs_task_memory" {
  type    = number
  default = 1024
}

variable "sm_recovery_window_in_days" {
  type = number
}
