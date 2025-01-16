output "private_ip" {
  value = aws_instance.default.private_ip
}

output "instance_id" {
  value = aws_instance.default.id
}
