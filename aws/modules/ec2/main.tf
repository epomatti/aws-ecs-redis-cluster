locals {
  name = "admin"
}

resource "aws_instance" "default" {
  ami           = var.ami
  instance_type = var.instance_type

  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.default.id]

  iam_instance_profile = var.iam_instance_profile_id
  user_data            = file("${path.module}/userdata/ubuntu.sh")

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  monitoring    = false
  ebs_optimized = true

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 20

    tags = {
      Name = "${var.workload}-${local.name}-os-disk"
    }
  }

  lifecycle {
    ignore_changes = [
      user_data
    ]
  }

  tags = {
    Name = local.name
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "default" {
  name        = "ec2-ssm-${var.workload}-${local.name}"
  description = "Controls access for EC2 via Session Manager"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-ssm-${var.workload}-${local.name}"
  }
}

resource "aws_security_group_rule" "http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}
