variable "project_name" {
  description = "Name of this project"
  default     = "toydeploy"
}

variable "aws_profile" {
  description = "AWS profile to pull credentials from"
  default     = "default"
}

variable "aws_region" {
  description = "Region to provision in"
  default     = "us-west-1"
}

variable "key_name" {
  description = "Key Pair name"
  default     = "toydeploy"
}

variable "cidr_vpc" {
  description = "CIDR block for VPC"
  default     = "10.1.0.0/16"
}

variable "cidr_subnet" {
  description = "CIDR block for subnet"
  default     = "10.1.0.0/20"
}

variable "instance_type" {
  description = "Instance type to provision"
  default     = "t4g.micro"
}

variable "ami_id" {
  description = "AMI for Ubuntu 18.04 in the region for the instance type"
  # default     = "ami-083f68207d3376798" # Ubuntu 18.04 (Intel)
  default = "ami-08e45d0d0a04bc682" # Ubuntu 18.04 (Arm)
}
