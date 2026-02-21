output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}

output "app_ip" {
  value = aws_instance.app.private_ip
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.cert.arn
}