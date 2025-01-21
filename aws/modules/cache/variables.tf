variable "workload" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "parameter_group" {
  type = string
}

variable "node_type" {
  type = string
}

variable "num_cache_clusters" {
  type = string
}

variable "auth_token" {
  type      = string
  sensitive = true
}
