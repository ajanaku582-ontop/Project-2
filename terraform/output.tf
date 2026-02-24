output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}

output "app_ip" {
  value = aws_instance.app.public_ip
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "db_ip" {
  value = aws_db_instance.postgres.address
}