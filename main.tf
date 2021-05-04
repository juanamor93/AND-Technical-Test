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
# VPC Module
module "vpc" {
  source = "./aws-modules/vpc"
  vpc_id = module.vpc.vpc_id
}
# EC2 Module
/*module "webservers" {
    source = "./aws-modules/ec2-instances"
    vpc_id = module.vpc.vpc_id
    security_group_id = module.vpc.security_group_id
} */


# ALB Module
module "load-balancer" {
  source = "./aws-modules/load-balancer"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.subnet_id

}  

module "autoscaling" {
  source = "./aws-modules/autoscaling"
  security_groups = module.vpc.security_group_id 
  subnets = module.vpc.subnet_id
  target_group_arn = module.load-balancer.target_group_arn
} 