output "subnets" {
  value = [aws_subnet.elb1.id, aws_subnet.elb2.id, aws_subnet.elb3.id]
}
