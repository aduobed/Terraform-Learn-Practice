terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

#Configure VPC and subnets
provider "aws" {
  region = "us-east-2"
}

# This is a way to capture and reference variables in terraform
variable "vpc_cidr_block" {
  description = "value of the vpc cidr block"
  type = string
}

# This is a way to capture and reference variables in terraform
variable "subnet_cidr_block" {
  description = "value of the subnet cidr block"
  type = string
}

variable "environment" {
  description = "value of the resource environment"
}

resource "aws_vpc" "development-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "development-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "development-subnet-1" {
  vpc_id            = aws_vpc.development-vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "development-subnet-1"
    Environment = var.environment
  }

}
data "aws_vpc" "existing-vpc" {
  default = true
}

resource "aws_subnet" "development-subnet-2" {
  vpc_id            = data.aws_vpc.existing-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "us-east-2a"
  tags = {
    Name = "development-subnet-2"
    Environment = var.environment
  }
}

output "development_vpc_id" {
  value = aws_vpc.development-vpc.id
}

output "development_subnet_id" {
  value = aws_subnet.development-subnet-2.id
}
