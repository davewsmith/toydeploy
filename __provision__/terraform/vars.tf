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
  default     = "us-west-1" # Require matching AMI below
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
  default     = "t4g.micro" # Note: architecture much match AMI below
}

# AMI must match region and instance architecture
# See https://cloud-images.ubuntu.com/locator/ec2
variable "ami_id" {
  description = "AMI for Ubuntu in us-west-1"
  type        = string
  default     = "ami-05ecf9bf2c10f48cc" # Ubuntu 20.04 (Arm)
  # default     = "ami-05243f78b8d58410b" # Ubuntu 20.04 (Intel)
  # default     = "ami-08e45d0d0a04bc682" # Ubuntu 18.04 (Arm)
  # default     = "ami-083f68207d3376798" # Ubuntu 18.04 (Intel)
}
