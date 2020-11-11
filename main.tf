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
  cidr_block           = "1.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Terraform Dev East"
  }
}

resource "aws_internet_gateway" "dev_east_igw" {
  vpc_id = aws_vpc.dev_east.id

  tags = {
    Name = "Terraform Dev East Internet Gateway"
  }
}

resource "aws_route_table" "dev_east_rt" {
  vpc_id = aws_vpc.dev_east.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_east_igw.id
  }

  tags = {
    Name = "Terraform Dev East Route Table"
  }
}

resource "aws_main_route_table_association" "dev_east_rt_main" {
  vpc_id         = aws_vpc.dev_east.id
  route_table_id = aws_route_table.dev_east_rt.id
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

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allows inbound SSH traffic"
  vpc_id      = aws_vpc.dev_east.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound traffic to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = "Terraform Dev East Key Pair"
  subnet_id                   = aws_subnet.dev_east_az1.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "Terraform Bastion Host"
  }
}
