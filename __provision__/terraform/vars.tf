variable "project_name" {
  description = "Name of this project"
  type        = string
  default     = "toydeploy"
}

variable "aws_profile" {
  description = "AWS profile to pull credentials from"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "Region to provision in"
  type        = string
  default     = "us-west-1"
}

variable "key_name" {
  description = "Key Pair name"
  type        = string
  default     = "toydeploy"
}

variable "cidr_vpc" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "cidr_subnet" {
  description = "CIDR block for subnet"
  type        = string
  default     = "10.1.0.0/20"
}

variable "instance_type" {
  description = "Instance type to provision"
  type        = string
  default     = "t4g.micro"
}

variable "ami_id" {
  description = "AMI for Ubuntu 18.04 in the region for the instance type"
  type        = string
  # default     = "ami-083f68207d3376798" # Ubuntu 18.04 (Intel)
  default = "ami-08e45d0d0a04bc682" # Ubuntu 18.04 (Arm)
}
