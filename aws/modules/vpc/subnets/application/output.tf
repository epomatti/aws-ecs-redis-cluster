output "subnets" {
  value = [aws_subnet.app1.id, aws_subnet.app2.id, aws_subnet.app3.id]
}
