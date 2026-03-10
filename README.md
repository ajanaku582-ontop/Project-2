
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

STRUCTURAL ARCHITECTURE

├project/
│
├── terraform/
│   ├── main.tf
│   ├── vpc.tf
│   ├── ec2.tf
│   ├── rds.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── inventory.tpl
│   └── terraform.tfvars
│
├── ansible/
│   ├── deploy.yml
│   └── ansible.cfg
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
└── README.md

FINAL ARCHITECTURE

                GitHub Actions
                      │
                      ▼
               Terraform Apply
                      │
                      ▼
                AWS Infrastructure
                      │
        ┌─────────────┴─────────────┐
        ▼                           ▼
   Bastion Server              Private App Server
  (Public Subnet)               (Private Subnet)
        │                           │
        │ SSH Jump                  │
        └──────────────►────────────┘
                      │
                      ▼
                  PostgreSQL RDS