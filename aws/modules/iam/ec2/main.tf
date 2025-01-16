resource "aws_iam_instance_profile" "default" {
  name = "${var.workload}-admin-ec2-profile"
  role = aws_iam_role.default.id
}

resource "aws_iam_role" "default" {
  name = "${var.workload}-admin-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "custom" {
  name = "${var.workload}-ecs-task-execution-custom"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SecretsManager"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:CreateSecret",
          "secretsmanager:UpdateSecret",
        ]
        Resource = [
          "${var.private_key_secret_arn}",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm-managed-instance-core" {
  role       = aws_iam_role.default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
