#include VPC,subnet,route53,availability zone ids
module "cars_aws_network_ids" {
  source = "git::ssh://git@git.cars.com/ter/cars-terraform-module-aws-network-ids.git"
}

module "resources" {
  source                    = "../resources"
  env                       = "pilot"
  cars-env                  = "pilot"
  aws-infra-env             = "pilot"
  vpc-id                    = "${lookup(module.cars_aws_network_ids.vpc_id, "pilot.us-east-1")}"
  image_name                = "vad1mo/hello-world-rest"
  cron_time                 = "cron(13 18 * * ? *)"
}

#Set the AWS provider
provider "aws" {
  profile = "pilot"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    profile = "pilot"
    region = "us-east-1"
    bucket = "michalak-terraform-state"
    key = "inv-pipe-s3-lambda/pilot/inv-pipe-s3-lambda.tfstate"
  }
}
