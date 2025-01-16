locals {
  app_name = "app-${var.workload}"
}

resource "aws_ecs_cluster" "main" {
  name = "cluster-${var.workload}"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "fargate" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "main" {
  family             = "ecs-task-${var.workload}"
  network_mode       = "awsvpc"
  cpu                = var.task_cpu
  memory             = var.task_memory
  execution_role_arn = var.ecs_task_execution_role_arn
  task_role_arn      = var.ecs_task_role_arn

  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      "name" : "${local.app_name}",
      "image" : "${var.ecr_repository_url}:latest",
      "environment" : [
        { "name" : "PORT", "value" : "80" },
        { "name" : "REDIS_HOST", "value" : "${var.primary_redis_endpoint}" },
        { "name" : "REDIS_PORT", "value" : "${var.redis_port}" },
        { "name" : "REDIS_CONNECT_TIMEOUT", "value" : "5000" },
        { "name" : "REDIS_PASSWORD", "value" : "${var.redis_auth_token}" },
        { "name" : "REDIS_TLS", "value" : "1" },
      ],
      "secrets" : [
        { name = "PRIVATE_KEY", "valueFrom" : "${var.private_key_secret_arn}" }
      ],
      "healthCheck" : {
        "retries" : 3,
        "command" : [
          "CMD-SHELL",
          "curl -f http://localhost:80/health || exit 1",
        ],
        "timeout" : 5,
        "interval" : 10,
        "startPeriod" : 10,
      },
      "essential" : true,
      "portMappings" : [
        {
          "protocol" : "tcp",
          "containerPort" : 80,
          "hostPort" : 80
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-region" : "${var.aws_region}",
          "awslogs-group" : "${aws_cloudwatch_log_group.ecs.name}",
          "awslogs-stream-prefix" : "${local.app_name}",
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "ecs-${var.workload}"
  retention_in_days = 365
}

resource "aws_ecs_service" "main" {
  name                               = "ecs-service-${var.workload}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  scheduling_strategy                = "REPLICA"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE"
    weight            = 1
  }

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.all.id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = local.app_name
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}


### Network ###
data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "all" {
  name        = "fargate-${var.workload}"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-fargate-${var.workload}"
  }
}

resource "aws_security_group_rule" "ingress_http" {
  description       = "Allows HTTP ingress from ELB"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.all.id
}

resource "aws_security_group_rule" "egress_http" {
  description       = "Allows HTTP egress, required to get credentials"
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.all.id
}

resource "aws_security_group_rule" "egress_https" {
  description       = "Allows HTTPS egress"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.all.id
}

resource "aws_security_group_rule" "egress_redis" {
  description       = "Allows REDIS egress"
  type              = "egress"
  from_port         = var.redis_port
  to_port           = var.redis_port
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.all.id
}
