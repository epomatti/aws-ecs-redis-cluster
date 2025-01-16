output "private_key_secret_arn" {
  value = aws_secretsmanager_secret.private_key.arn
}
