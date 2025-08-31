terraform {
  backend "s3" {
    bucket  = "datacynth-dev-tfstate"
    key     = "vpc/terraform.tfstate"
    region  = "us-west-2"
    profile = "devadmin"
  }
}