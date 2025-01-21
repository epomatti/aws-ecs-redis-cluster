output "private_key_secret_arn" {
  value = aws_secretsmanager_secret.private_key.arn
}

output "private_key_secret_name" {
  value = aws_secretsmanager_secret.private_key.name
}

output "private_key_password_secret_arn" {
  value = aws_secretsmanager_secret.private_key_password.arn
}

output "private_key_password_secret_name" {
  value = aws_secretsmanager_secret.private_key_password.name
}
