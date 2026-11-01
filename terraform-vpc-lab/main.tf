terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_vpc" "devops_lab" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "AWS-DevOps-Terraform-VPC"
  }
}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.devops_lab.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "AWS-DevOps-Terraform-Public-Subnet"
  }
}
resource "aws_internet_gateway" "devops_lab" {
  vpc_id = aws_vpc.devops_lab.id

  tags = {
    Name = "AWS-DevOps-Terraform-IGW"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.devops_lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_lab.id
  }

  tags = {
    Name = "AWS-DevOps-Terraform-Public-RT"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
resource "aws_security_group" "web" {
  name        = "terraform-web-sg"
  description = "Security group for Terraform web server"
  vpc_id      = aws_vpc.devops_lab.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AWS-DevOps-Terraform-Web-SG"
  }
}
resource "aws_instance" "web" {
  ami           = "ami-0a4d112af46bb0d62"
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids     = [aws_security_group.web.id]
  associate_public_ip_address = true
  iam_instance_profile       = aws_iam_instance_profile.ec2_ssm.name

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
  EOF
  user_data_replace_on_change = true
  tags = {
    Name = "AWS-DevOps-Terraform-Web"
  }

}
resource "aws_iam_role" "ec2_ssm" {
  name = "AWS-DevOps-Terraform-EC2-SSM-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "AWS-DevOps-Terraform-EC2-SSM-Profile"
  role = aws_iam_role.ec2_ssm.name
}