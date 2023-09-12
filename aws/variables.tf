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
