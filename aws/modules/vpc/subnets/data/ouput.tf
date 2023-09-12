output "subnets" {
  value = [aws_subnet.data1.id, aws_subnet.data2.id, aws_subnet.data3.id]
}

output "route_tables" {
  value = [aws_route_table.data1.id, aws_route_table.data2.id, aws_route_table.data3.id]
}
