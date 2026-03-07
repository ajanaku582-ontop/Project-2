
Overview

My project provisions a cloud infrastructure on AWS using Terraform and configures the deployed instances Nginx, App, Bastion and Postgres servers using Ansible.

The infrastructure includes:

EC2 instances:

Nginx server (frontend, public)

Application server (backend, private)

Bastion host (for secure access to private instances)

RDS Postgres database

Application Load Balancer (ALB)

Security Groups and IAM roles (including SSM role for Session Manager)

Ansible handles OS hardening and deployment of application and Nginx configuration.terraform/

├── main.tf
├── variables.tf
├── outputs.tf
├── inventory.ini
ansible/
├── playbook.yml
├── roles/
│   └── os-hardening/
│       ├── tasks/
│       │   └── main.yml
│       └── defaults/
│           └── main.yml