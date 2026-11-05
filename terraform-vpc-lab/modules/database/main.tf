variable "database_security_group_id" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "db_subnet_ids" {
  type = list(string)
}

resource "aws_db_subnet_group" "postgres" {
  name = "aws-devops-postgres-subnet-group"

  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "AWS-DevOps-Terraform-Postgres-Subnet-Group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "aws-devops-postgres"
  lifecycle {
    ignore_changes = [
      password
    ]
  }

  engine         = "postgres"
  engine_version = "17"

  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"

  db_name                = "devopsdb"
  username               = "devopsadmin"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [var.database_security_group_id]

  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0

  tags = {
    Name = "AWS-DevOps-Terraform-Postgres"
  }
}