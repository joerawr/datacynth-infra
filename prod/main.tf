provider "aws" {
  profile = "prodadmin"
  region  = "us-west-2"
}

module "vpc" {
  source = "github.com/joerawr/datacynth-tf-modules/vpc?ref=main"

  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  az_count             = var.az_count
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  nat_instance_type    = var.nat_instance_type
  aws_profile          = "prodadmin"
  aws_region           = "us-west-2"
}
