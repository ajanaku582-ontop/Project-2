# output "nginx_node_ip" {
# value = aws_instance.nginx.public_ip
# }

output "app_node_ip" {
  value = aws_instance.app.public_ip
}

output "bastion_node_ip" {
  value = aws_instance.bastion.public_ip
}

output "db_node_ip" {
  value = aws_db_instance.postgres.address
}
