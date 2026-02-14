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
