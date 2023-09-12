### Routes ###
resource "aws_route_table" "elb1" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.interget_gateway_id
  }

  tags = {
    Name = "rt-${var.workload}-elb1"
  }
}

resource "aws_route_table" "elb2" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.interget_gateway_id
  }

  tags = {
    Name = "rt-${var.workload}-elb2"
  }
}

resource "aws_route_table" "elb3" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.interget_gateway_id
  }

  tags = {
    Name = "rt-${var.workload}-elb3"
  }
}

### Subnets ###

resource "aws_subnet" "elb1" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.10.0/24"
  availability_zone = var.az1

  # CKV_AWS_130
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-elb1"
  }
}

resource "aws_subnet" "elb2" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.11.0/24"
  availability_zone = var.az2

  # CKV_AWS_130
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-elb2"
  }
}

resource "aws_subnet" "elb3" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.12.0/24"
  availability_zone = var.az3

  # CKV_AWS_130
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-elb3"
  }
}

### Routes ###

resource "aws_route_table_association" "elb1" {
  subnet_id      = aws_subnet.elb1.id
  route_table_id = aws_route_table.elb1.id
}

resource "aws_route_table_association" "elb2" {
  subnet_id      = aws_subnet.elb2.id
  route_table_id = aws_route_table.elb2.id
}

resource "aws_route_table_association" "elb3" {
  subnet_id      = aws_subnet.elb3.id
  route_table_id = aws_route_table.elb3.id
}
