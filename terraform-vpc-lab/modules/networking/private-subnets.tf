resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.devops_lab.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "AWS-DevOps-Terraform-Private-Subnet-A"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.devops_lab.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "AWS-DevOps-Terraform-Private-Subnet-B"
  }
}