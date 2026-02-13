provider "aws" {
  region = var.region
}

####################
# VPC
####################
resource "aws_vpc" "grace_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "grace-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.grace_vpc.id

  tags = {
    Name = "grace-igw"
  }
}


####################
# Subnets
####################
resource "aws_subnet" "public" {
  count                   = 1
  vpc_id                  = aws_vpc.grace_vpc.id
  cidr_block              = ["10.0.1.0/24"][count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "grace-public-sub-${count.index + 1}"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "grace_private" {
  count             = 1
  vpc_id            = aws_vpc.grace_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "grace-private-sub-${count.index + 1}"
  }
}

####################
# Security Groups
####################
resource "aws_security_group" "grace" {
  vpc_id = aws_vpc.grace_vpc.id
  name   = "grace-sg"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

}
#####################
# NAT Gateway Setup
#####################
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "grace" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "grace-nat"
  }
}

#####################
# Public Route Table
#####################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.grace_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "grace-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#####################
# Private Route Table
#####################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.grace_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.grace.id
  }

  tags = {
    Name = "grace-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.grace_private[count.index].id
  route_table_id = aws_route_table.private.id
}

####################
# NGINX Instances (Public)
####################
resource "aws_instance" "nginx" {
  count                       = 1
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[count.index].id
  vpc_security_group_ids      = [aws_security_group.grace.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  
#   user_data = <<-EOF
#                 #!/bin/bash
               
#                 echo "Starting Nginx installation..."
                
#                 # Update system
#                 sudo yum update -y
                
#                 # Install Nginx
#                 sudo amazon-linux-extras install nginx1 -y
                
#                 # Create custom landing page
  
                
#                 # Start Nginx
#                 sudo systemctl enable nginx
#                 sudo systemctl start nginx
                
#                 # Check if Nginx is running
#                 sudo systemctl status nginx
                
#                 echo "Nginx installation completed!"
# EOF


  tags = { Name = "nginx-${count.index}" }
}

####################
# App Instances (Private)
####################
resource "aws_instance" "app" {
  count                  = 1
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.grace_private[count.index].id
  vpc_security_group_ids = [aws_security_group.grace.id]
  key_name               = var.key_name
#   user_data = <<-EOF
#     #!/bin/bash
#     yum update -y
#     amazon-linux-extras install -y python3
#     python3 -m venv /opt/venv
#     source /opt/venv/bin/activate
#     pip install flask
#   EOF

  tags = { Name = "app-${count.index}" }
}

####################
# PostgreSQL Instance (Private)
####################
resource "aws_db_subnet_group" "grace" {
  name = "grace-db-subnet-group"

  subnet_ids = [
    aws_subnet.grace_private[0].id]

  tags = {
    Name = "grace-db-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "grace-postgres"

  engine         = "postgres"
  engine_version = "14.19"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_encrypted = false

  db_name  = "gracedb"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.grace.name
  vpc_security_group_ids = [aws_security_group.db.id]

  backup_retention_period = 0
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
  # db_subnet_group_name    = aws_db_subnet_group.grace.name
  # vpc_security_group_ids  = [aws_security_group.db.id]

  tags = {
    Name = "Grace-postgres"
  }
}

resource "aws_security_group" "db" {
  vpc_id = aws_vpc.grace_vpc.id
  name   = "grace-db-sg"

ingress {
  from_port       = 5432
  to_port         = 5432
  protocol        = "tcp"
  security_groups = [aws_security_group.grace.id]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}