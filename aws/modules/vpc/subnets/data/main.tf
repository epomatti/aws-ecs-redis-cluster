### Route Tables ###

resource "aws_route_table" "data1" {
  vpc_id = var.vpc_id
  tags = {
    Name = "rt-${var.workload}-dat1"
  }
}

resource "aws_route_table" "data2" {
  vpc_id = var.vpc_id
  tags = {
    Name = "rt-${var.workload}-dat2"
  }
}

resource "aws_route_table" "data3" {
  vpc_id = var.vpc_id
  tags = {
    Name = "rt-${var.workload}-dat3"
  }
}

### Subnets ###

resource "aws_subnet" "data1" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.90.0/24"
  availability_zone       = var.az1
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-dat1"
  }
}

resource "aws_subnet" "data2" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.91.0/24"
  availability_zone       = var.az2
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-dat2"
  }
}

resource "aws_subnet" "data3" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.92.0/24"
  availability_zone       = var.az3
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.workload}-dat3"
  }
}

### Routes ###

resource "aws_route_table_association" "data1" {
  subnet_id      = aws_subnet.data1.id
  route_table_id = aws_route_table.data1.id
}

resource "aws_route_table_association" "data2" {
  subnet_id      = aws_subnet.data2.id
  route_table_id = aws_route_table.data2.id
}

resource "aws_route_table_association" "data3" {
  subnet_id      = aws_subnet.data3.id
  route_table_id = aws_route_table.data3.id
}
