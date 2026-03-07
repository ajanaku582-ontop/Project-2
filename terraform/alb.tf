# # ----------------------------
# # ALB SECURITY GROUP
# # ----------------------------
# resource "aws_security_group" "alb_sg" {
#   name        = "alb-sg"
#   description = "Allow HTTPS from internet"
#   vpc_id      = aws_vpc.main.id

#   # HTTPS
#   ingress {
#     description = "HTTPS from internet"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # HTTP (optional redirect)
#   ingress {
#     description = "HTTP from internet"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Allow outbound to app
#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # ----------------------------
# # APP SECURITY GROUP
# # ----------------------------
# resource "aws_security_group" "app_sg" {
#   name        = "app-sg"
#   description = "Allow traffic from ALB only"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     description     = "App port from ALB"
#     from_port       = 8000
#     to_port         = 8000
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb_sg.id]
#   }

#   # Allow outbound (internet via NAT + DB)
#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # ----------------------------
# # DB SECURITY GROUP
# # ----------------------------
# resource "aws_security_group" "db_sg" {
#   name        = "db-sg"
#   description = "Allow Postgres from App only"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     description     = "Postgres from App"
#     from_port       = 5432
#     to_port         = 5432
#     protocol        = "tcp"
#     security_groups = [aws_security_group.app_sg.id]
#   }

#   # DB should not need internet, but allow responses
#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_lb" "alb" {
#   load_balancer_type = "application"

#   subnets = [
#     aws_subnet.public1.id,
#     aws_subnet.public2.id
#   ]

#   security_groups = [aws_security_group.alb_sg.id]
# }

# resource "aws_lb_target_group" "tg" {
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id
# }

# resource "aws_lb_target_group_attachment" "attach" {
#   target_group_arn = aws_lb_target_group.tg.arn
#   target_id        = aws_instance.nginx.id
#   port             = 80
# }

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = 443
#   protocol          = "HTTPS"

#   certificate_arn = aws_acm_certificate.cert.arn

#   default_action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.tg.arn
#   }
# }