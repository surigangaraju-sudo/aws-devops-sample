resource "aws_security_group" "database" {
  name        = "terraform-database-sg"
  description = "Security group for Terraform PostgreSQL database"
  vpc_id      = aws_vpc.devops_lab.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AWS-DevOps-Terraform-Database-SG"
  }
}
resource "aws_vpc_security_group_ingress_rule" "database_from_web" {
  security_group_id            = aws_security_group.database.id
  referenced_security_group_id = aws_security_group.web.id

  from_port = 5432
  to_port   = 5432
  ip_protocol = "tcp"
}