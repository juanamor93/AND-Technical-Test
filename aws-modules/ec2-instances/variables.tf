variable "aws_region" {
	default = "eu-west-2"
}

variable "subnets_cidr" {
	type = list
	default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_id" {
	default = "vpc-0971bdeda4fe3e1f0"
}

variable "security_group_id" {
	
}
#temporary
#variable "subnet_id" {

#}

variable "webservers_ami" {
  default = "ami-093d2024466a862c1"
}
