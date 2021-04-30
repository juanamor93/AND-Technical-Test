# Security Group
resource "aws_security_group" "web_server_sg" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id = var.vpc_id

ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}