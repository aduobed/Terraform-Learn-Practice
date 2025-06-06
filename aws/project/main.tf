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

variable "availability_zone" {
  description = "value of the availability zone"
  type = string
}

variable "environment_prefix" {
  description = "value of the resource environment"
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "myapp-${var.environment_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = "myapp-${var.environment_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name = "myapp-${var.environment_prefix}-igw"
  }
}

resource "aws_route_table" "myapp-aws_route_table" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name = "myapp-${var.environment_prefix}-route-table"
  }
}

resource "aws_route_table_association" "myapp-aws_route_table_association" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-aws_route_table.id
}