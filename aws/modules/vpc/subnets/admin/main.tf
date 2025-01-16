### Routes ###
resource "aws_route_table" "admin" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "rt-${var.workload}-admin"
  }
}

### Subnets ###

resource "aws_subnet" "admin" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.111.0/24"
  availability_zone = var.az1

  # CKV_AWS_130
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-admin"
  }
}

### Routes ###
resource "aws_route_table_association" "admin" {
  subnet_id      = aws_subnet.admin.id
  route_table_id = aws_route_table.admin.id
}
