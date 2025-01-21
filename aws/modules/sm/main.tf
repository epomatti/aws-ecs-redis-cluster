resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_secretsmanager_secret" "private_key" {
  name                    = "${var.workload}/private-key/${random_string.random.result}"
  recovery_window_in_days = var.recovery_window_in_days
  description             = "Private key for the workload"
}

resource "aws_secretsmanager_secret" "private_key_password" {
  name                    = "${var.workload}/private-key-password/${random_string.random.result}"
  recovery_window_in_days = var.recovery_window_in_days
  description             = "Password for the private key"
}
