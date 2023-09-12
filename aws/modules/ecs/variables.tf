variable "workload" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "primary_redis_endpoint" {
  type = string
}

variable "redis_port" {
  type = string
}

variable "redis_auth_token" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "task_cpu" {
  type = number
}

variable "task_memory" {
  type = number
}

variable "ecr_repository_url" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}
