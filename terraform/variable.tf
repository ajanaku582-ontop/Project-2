variable "region" { default = "us-east-2" }
variable "instance_type" { default = "c7i-flex.large" }
variable "key_name" {}
variable "ami_id" {}
variable "db_password" {
  type = string

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Password must be at least 8 characters."
  }
}
variable "domain_name" {
  description = "Your domain for ACM certificate (e.g., ennyontop1.duckdns.org)"
  type        = string
}