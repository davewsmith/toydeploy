terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-1"
}

variable "cidr_vpc" {
  description = "CIDR block for VPC"
  default     = "10.1.0.0/16"
}

variable "cidr_subnet" {
  description = "CIDR block for subnet"
  default     = "10.1.0.0/20"
}

resource "aws_vpc" "toydeploy-vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "toydeploy-vpc"
  }
}

resource "aws_subnet" "toydeploy-subnet" {
  vpc_id                  = aws_vpc.toydeploy-vpc.id
  cidr_block              = var.cidr_subnet
  map_public_ip_on_launch = true
}

resource "aws_security_group" "toydeploy-sg" {
  name   = "toydeploy-sg"
  vpc_id = aws_vpc.toydeploy-vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  # Terraform removes the default rule, so we re-add it.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "toydeploy" {
  ami             = "ami-083f68207d3376798" # Ubuntu 18.04
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.toydeploy-sg.id}"]
  subnet_id       = aws_subnet.toydeploy-subnet.id
  key_name        = "toydeploy"

  tags = {
    Name = "Toy Deploy"
  }
}
