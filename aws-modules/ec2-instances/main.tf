
# Return VPC Subnet IDs
data "aws_subnet_ids" "public" {
  vpc_id = var.vpc_id
  
}

# EC2 Instances
resource "aws_instance" "webservers" {
for_each =  data.aws_subnet_ids.public.ids   
ami = var.webservers_ami
instance_type = var.instance_type
subnet_id = each.value 

    user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd.x86_64
    systemctl start httpd.service
    systemctl enable httpd.service
    echo “Hello World from $(hostname -f)” > /var/www/html/index.html
    EOF

tags = {
    Name = "webserver"
  }
}


