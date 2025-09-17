provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "ECS ElastiCache Sandbox"
    }
  }
}
