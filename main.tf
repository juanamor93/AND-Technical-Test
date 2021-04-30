  
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.7"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}

module "vpc" {
  source = "./aws-modules/vpc"
}

module "web_server_sg" {
  source = "./aws-modules/security-group"
  vpc_id = module.vpc.vpc_id
}



/* module "webserver" {
    source = "./aws-modules/ec2-instance"

    servername = ""
    size = "t3.micro"
  
} */

