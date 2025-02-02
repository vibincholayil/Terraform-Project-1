terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-west-2"
}

# Reference an existing VPC
resource "aws_subnet" "my_subnet" {
  vpc_id                  = "vpc-0e4118d674e707618"  # Your existing VPC ID
  cidr_block              = "12.0.0.0/16"
  map_public_ip_on_launch = true
  tags = {
    Name = "MySubnet"
  }
}

# Create a security group inside the existing VPC
resource "aws_security_group" "microservices_SG"  {
  vpc_id = "vpc-0e4118d674e707618"  # Your existing VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "microservices_SG"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-091f18e98bc129c4e"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform_Demo"
  }
}
