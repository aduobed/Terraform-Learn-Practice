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

resource "aws_vpc" "development-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name    = "development-vpc"
  }
}

resource "aws_subnet" "development-subnet-1" {
  vpc_id            = aws_vpc.development-vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "development-subnet-1"
  }

}
data "aws_vpc" "existing-vpc" {
  default = true
}

resource "aws_subnet" "development-subnet-2" {
  vpc_id            = data.aws_vpc.existing-vpc.id
  cidr_block        = "172.31.48.0/20"
  availability_zone = "us-east-2a"
  tags = {
    Name = "development-subnet-2"
  }
}

output "development_vpc_id" {
  value = aws_vpc.development-vpc.id
}

output "development_subnet_id" {
  value = aws_subnet.development-subnet-2.id
}