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