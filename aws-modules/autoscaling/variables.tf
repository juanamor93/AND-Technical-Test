variable "instance_type" {
  default = "t2.micro"
}

variable "webservers_ami" {
  default = "ami-093d2024466a862c1"
}

variable "subnets" {}

variable "security_groups" {}

variable "target_group_arn" {}