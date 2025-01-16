output "private_key_secret_arn" {
  value = aws_secretsmanager_secret.private_key.arn
}

output "private_key_secret_name" {
  value = aws_secretsmanager_secret.private_key.name
}
