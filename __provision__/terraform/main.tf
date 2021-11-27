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

resource "aws_instance" "toydeploy" {
  ami           = "ami-083f68207d3376798"  # Ubuntu 18.04
  instance_type = "t2.micro"
  key_name      = "toydeploy"

  tags = {
    Name = "Toy Deploy webserver"
  }
}
