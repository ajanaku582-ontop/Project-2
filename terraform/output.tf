output "nginx_public_ips" {
  value = aws_instance.nginx[*].public_ip
}

output "app_private_ips" {
  value = aws_instance.app[*].private_ip
}

output "postgres_endpoint" {
  value = aws_db_instance.postgres.endpoint
}