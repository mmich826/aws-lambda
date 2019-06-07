########################################################################################
#
# Include modules
#
########################################################################################
#Set up main.tf file about subnet

# Include the account module
module "cars_aws_account" {
  source = "git::ssh://git@git.cars.com/ter/cars-terraform-module-aws-account.git"
}

#include Region
module "cars_region" {
  source = "git::ssh://git@git.cars.com/ter/cars-terraform-module-aws-region.git"
}

#include VPC,subnet,route53,availability zone ids
module "cars_aws_network_ids" {
  source = "git::ssh://git@git.cars.com/ter/cars-terraform-module-aws-network-ids.git"
}

#include AMI
module "cars_aws_ami" {
  source = "git::ssh://git@git.cars.com/ter/cars-terraform-module-aws-ami.git//np"
}

variable "project-name" {
  default = "inventory-pipeline"
}

variable "env" {}
variable "cars-env" {}
variable "aws-infra-env" {}
variable "vpc-id" {}
variable "image_name" {}
variable "cron_time" {}
