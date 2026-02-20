Internet
   │
 HTTPS (443)
   │
┌───────────────┐
│  ALB (Public) │
└──────┬────────┘
       │
       ▼
┌───────────────┐
│  App EC2      │ (Private Subnet)
│  FastAPI      │
└──────┬────────┘
       │
       ▼
┌───────────────┐
│  RDS Postgres │ (Private DB Subnet)
└───────────────┘

Admin → SSM (preferred) OR Bastion → App

The solution implements a secure, layered architecture following the principle of least privilege. The application and database tiers are deployed within private subnets, preventing direct internet access. An Application Load Balancer is used as the sole public entry point, terminating HTTPS traffic. Administrative access is achieved through AWS Systems Manager Session Manager, eliminating the need for SSH exposure. Sensitive credentials are stored in AWS Secrets Manager, and IAM roles are used to avoid hardcoded credentials. Network security is enforced through tightly scoped security groups, ensuring that only required communication paths are allowed between components.