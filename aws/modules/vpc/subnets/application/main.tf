### Routes ###
resource "aws_route_table" "app1" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.interget_gateway_id
  }

  tags = {
    Name = "rt-${var.workload}-app1"
  }
}

resource "aws_route_table" "app2" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.interget_gateway_id
  }

  tags = {
    Name = "rt-${var.workload}-app2"
  }
}

resource "aws_route_table" "app3" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.interget_gateway_id
  }

  tags = {
    Name = "rt-${var.workload}-app3"
  }
}

### Subnets ###

resource "aws_subnet" "app1" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.20.0/24"
  availability_zone = var.az1

  # CKV_AWS_130
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-app1"
  }
}

resource "aws_subnet" "app2" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.21.0/24"
  availability_zone = var.az2

  # CKV_AWS_130
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-app2"
  }
}

resource "aws_subnet" "app3" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.22.0/24"
  availability_zone = var.az3

  # CKV_AWS_130
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-app3"
  }
}

### Routes ###

resource "aws_route_table_association" "app1" {
  subnet_id      = aws_subnet.app1.id
  route_table_id = aws_route_table.app1.id
}

resource "aws_route_table_association" "app2" {
  subnet_id      = aws_subnet.app2.id
  route_table_id = aws_route_table.app2.id
}

resource "aws_route_table_association" "app3" {
  subnet_id      = aws_subnet.app3.id
  route_table_id = aws_route_table.app3.id
}
