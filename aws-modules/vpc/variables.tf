variable "aws_region" {
	default = "eu-west-2"
}

variable "vpc_id" {

}

variable "vpc_cidr" {
	default = "10.20.0.0/16"
}

variable "subnets_cidr" {
	type = list
	default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "azs" {
	type = list
	default = ["eu-west-2a", "eu-west-2b"]
}