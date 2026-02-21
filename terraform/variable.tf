variable "region" { default = "us-east-2" }
variable "instance_type" { default = "c7i-flex.large" }
variable "key_name" {}
variable "db_password" {
  type = string
}
variable "domain_name" {
  description = "Your domain for ACM certificate (e.g., ennyontop1.duckdns.org)"
  type        = string
}