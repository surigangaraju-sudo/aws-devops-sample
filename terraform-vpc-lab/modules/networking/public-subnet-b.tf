resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.devops_lab.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-southeast-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "AWS-DevOps-Terraform-Public-Subnet-B"
  }
}
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}