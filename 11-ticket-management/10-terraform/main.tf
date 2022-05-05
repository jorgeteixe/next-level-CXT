terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  backend "s3" {
    bucket  = "next-level-cxt-tfstate"
    key     = "lab-11-tfstate"
    region  = "eu-west-1"
    profile = "cxt"
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "cxt"
  region  = "eu-west-1"
}

#
# Variables
#

variable "availability_zone" {
  type = string
}

variable "public_key" {
  type = string
}

#
# Networking
#

resource "aws_vpc" "vpc" {
  cidr_block = "172.20.0.0/16"

  tags = {
    Name = "cxt-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "cxt-gateway"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.20.0.0/24"
  availability_zone = var.availability_zone
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "route_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

#
# SSH Key
#

resource "aws_key_pair" "next-level-cxt" {
  key_name   = "next-level-cxt"
  public_key = var.public_key
}

#
# Security
#

resource "aws_security_group" "sec_group" {
  name        = "cxt-11"
  description = "Allow SSH from VPS"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH from VPS"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["212.71.255.15/32"]
  }

  ingress {
    description = "HTTP 80 from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS 443 from everywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#
# Instance
#

resource "aws_instance" "instance" {
  ami                         = "ami-08ca3fed11864d6bb"
  instance_type               = "t2.micro"
  associate_public_ip_address = true

  subnet_id              = aws_subnet.subnet.id
  availability_zone      = var.availability_zone
  key_name               = aws_key_pair.next-level-cxt.key_name
  vpc_security_group_ids = [aws_security_group.sec_group.id]

  depends_on = [
    aws_internet_gateway.gw
  ]
}

#
# DNS
#

data "aws_route53_zone" "jtei" {
  name = "jtei.io."
}

resource "aws_route53_record" "instance0" {
  zone_id = data.aws_route53_zone.jtei.zone_id
  name    = "11.cxt.jtei.io"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.instance.public_ip]
}

#
# Output
#

output "public_ip0" {
  value = aws_instance.instance.public_ip
}
