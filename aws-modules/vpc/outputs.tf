output "vpc_id" {
  value = aws_vpc.web_vpc.id
}

output "subnet_id" {
  value = aws_subnet.public.*.id
 
}

output "security_group_id" {
    value = aws_default_security_group.web_server_sg.id
}


