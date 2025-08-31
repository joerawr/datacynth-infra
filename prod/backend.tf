terraform {
  backend "s3" {
    bucket  = "datacynth-prod-tfstate"
    key     = "vpc/terraform.tfstate"
    region  = "us-west-2"
    profile = "prodadmin"
  }
}