# output "nginx_node_ip" {
# value = aws_instance.nginx.public_ip
# }

# output "app_node_ip" {
#   value = aws_instance.app.private_ip
# }

# output "bastion_node_ip" {
#   value = aws_instance.bastion.public_ip
# }

output "inventory" {
  value = <<EOT
[bastion]
${aws_instance.bastion.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[app]
${aws_instance.app.private_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_ssh_common_args='-o ProxyJump=ubuntu@${aws_instance.bastion.public_ip}'
EOT
}
output "db_node_ip" {
  value = aws_db_instance.postgres.address
}
