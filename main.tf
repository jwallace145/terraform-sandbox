terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "dev_east" {
  cidr_block = "1.0.0.0/24"

  tags = {
    Name = "Terraform Dev East"
  }
}
