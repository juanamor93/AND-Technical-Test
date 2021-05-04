# ALB Security Group
resource "aws_security_group" "ssl-alb-sg"  {
    name = "ssl-alb-sg"
    vpc_id = var.vpc_id

     ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

    ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

tags = {
    Name = "ssl-alb-sg"
  }
}
# Application Load Balancer
resource "aws_alb" "ssl-alb" {
    name               = "ssl-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.ssl-alb-sg.id]
    subnets = var.subnets
}
# ALB Target Group
resource "aws_alb_target_group" "ssl-alb-tg" {
  name     = "ssl-alb-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = var.vpc_id 
}
# ALB SSL Listener
resource "aws_alb_listener" "ssl-alb-listener" {
  load_balancer_arn = aws_alb.ssl-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  depends_on        = [aws_alb_target_group.ssl-alb-tg]
  certificate_arn = "arn:aws:acm:eu-west-2:189365216318:certificate/1836357e-ee87-49f8-8d72-546b6d01ef34"
   
  default_action {
    target_group_arn = aws_alb_target_group.ssl-alb-tg.arn
    type             = "forward"
  }
}
# ALB HTTP Listener
resource "aws_alb_listener" "http-alb-listener" {
    load_balancer_arn = aws_alb.ssl-alb.arn
    port              = "80"
    protocol          = "HTTP"
    depends_on        = [aws_alb_target_group.ssl-alb-tg]

    default_action {
    target_group_arn = aws_alb_target_group.ssl-alb-tg.arn
    type             = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}



