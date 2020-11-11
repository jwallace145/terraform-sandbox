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

resource "aws_subnet" "dev_east_az1" {
  vpc_id            = aws_vpc.dev_east.id
  cidr_block        = "1.0.0.0/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Terraform Dev East Public Subnet AZ1"
  }
}

resource "aws_subnet" "dev_east_az2" {
  vpc_id            = aws_vpc.dev_east.id
  cidr_block        = "1.0.0.240/28"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Terraform Dev East Private Subnet AZ2"
  }
}

data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  key_name      = "Terraform Dev East Key Pair"
  subnet_id     = aws_subnet.dev_east_az1.id

  tags = {
    Name = "Terraform Bastion Host"
  }
}
