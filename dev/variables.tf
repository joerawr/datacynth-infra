variable "name" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "az_count" {
  default = 1
}

variable "public_subnet_count" {
  default = 1
}

variable "private_subnet_count" {
  default = 1
}

variable "nat_instance_type" {
  default = "t4g.micro"
}

variable "nat_instance_ami_filter" {
  default = "al2023-ami-2023.*-kernel-6.1-arm64"
}
