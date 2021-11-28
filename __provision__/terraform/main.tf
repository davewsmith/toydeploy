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

resource "aws_security_group" "app-sg" {
  name = "app-sg"

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
  ami               = "ami-083f68207d3376798" # Ubuntu 18.04
  instance_type     = "t2.micro"
  security_groups = [aws_security_group.app-sg.name]
  key_name          = var.key-name

  tags = {
    Name = "${var.project-name}_appserver"
  }
}
