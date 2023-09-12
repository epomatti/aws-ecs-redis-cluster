output "vpc_id" {
  value = aws_vpc.main.id
}

# Data
output "data_subnets" {
  value = module.data_subnets.subnets
}

output "data_subnets_route_tables" {
  value = module.data_subnets.route_tables
}

# Application
output "application_subnets" {
  value = module.application_subnets.subnets
}

# Balancer
output "elb_subnets" {
  value = module.balancer_subnets.subnets
}
