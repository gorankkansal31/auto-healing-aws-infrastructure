terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
     archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./modules/vpc"

  project_name           = "auto-healing"
  az_1                   = "ap-south-1a"
  az_2                   = "ap-south-1b"
  public_subnet_1_cidr   = "10.0.1.0/24"
  public_subnet_2_cidr   = "10.0.2.0/24"
  private_subnet_1_cidr  = "10.0.11.0/24"
  private_subnet_2_cidr  = "10.0.12.0/24"
}

module "security_groups" {
  source = "./modules/security_groups"

  project_name = "auto-healing"
  vpc_id       = module.vpc.vpc_id
}


module "ec2" {
  source = "./modules/ec2"

  project_name  = "auto-healing"
  //i_id        = "ami-xxxxxxxxx"
  instance_type = "t3.micro"
  ec2_sg_id     = module.security_groups.ec2_sg_id
  key_name      = "auto_healing"
}

module "alb" {
  source = "./modules/alb"

  project_name       = "auto-healing"
  vpc_id             = module.vpc.vpc_id
  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id
  alb_sg_id          = module.security_groups.alb_sg_id
}



module "asg" {
  source = "./modules/asg"

  project_name       = "auto-healing"
  launch_template_id = module.ec2.launch_template_id
  target_group_arn   = module.alb.target_group_arn
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
}

module "rds" {

  source = "./modules/rds"

  project_name = "auto-healing"
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  rds_sg_id  =  module.security_groups.rds_sg_id
  db_username = var.db_username
  db_password  = var.db_password
  }


module "sns" {
  
  source = "./modules/sns"
  project_name       = "auto-healing"
  notification_email = var.notification_email
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  project_name            = "auto-healing"
  asg_name                = module.asg.asg_name
  alb_arn_suffix          = module.alb.alb_arn_suffix
  target_group_arn_suffix = module.alb.target_group_arn_suffix
  sns_topic_arn           = module.sns.sns_topic_arn
}

module "lambda" {
  source = "./modules/lambda"

  project_name  = "auto-healing"
  sns_topic_arn = module.sns.sns_topic_arn
}