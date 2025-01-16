output "elb_dns_name" {
  value = module.elb.dns_name
}

output "private_key_secret_name" {
  value = module.secrets.private_key_secret_name
}

output "instance_id" {
  value = module.ec2_instance.instance_id
}
