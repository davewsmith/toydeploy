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

resource "aws_vpc" "app-vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project-name}-vpc"
  }
}

resource "aws_internet_gateway" "app-ig" {
  vpc_id = aws_vpc.app-vpc.id
}

resource "aws_route_table" "app-rt" {
  vpc_id = aws_vpc.app-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-ig.id
  }
}

resource "aws_subnet" "app-subnet" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = var.cidr_subnet
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "app-rta" {
  subnet_id      = aws_subnet.app-subnet.id
  route_table_id = aws_route_table.app-rt.id
}

resource "aws_security_group" "app-sg" {
  name   = "${var.project-name}-sg"
  vpc_id = aws_vpc.app-vpc.id

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

resource "aws_instance" "app-appserver" {
  ami             = "ami-083f68207d3376798" # Ubuntu 18.04
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.app-sg.id}"]
  subnet_id       = aws_subnet.app-subnet.id
  key_name        = var.key-name

  tags = {
    Name = "${var.project-name}_appserver"
  }
}
