resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_secretsmanager_secret" "private_key" {
  name                    = "${var.workload}/privatekey/${random_string.random.result}"
  recovery_window_in_days = var.recovery_window_in_days
}

# resource "aws_secretsmanager_secret_version" "rds_v0" {
#   secret_id     = aws_secretsmanager_secret.rds.id
#   secret_string = var.rds_postgresql_secret_string
# }
