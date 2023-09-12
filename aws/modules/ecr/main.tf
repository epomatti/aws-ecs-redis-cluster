resource "aws_ecr_repository" "main" {
  name                 = "ecr-${var.workload}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}
