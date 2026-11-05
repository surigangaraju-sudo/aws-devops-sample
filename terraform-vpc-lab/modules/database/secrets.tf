resource "aws_secretsmanager_secret" "rds" {
  name        = "aws-devops-terraform/rds"
  description = "Credentials for AWS DevOps Terraform PostgreSQL database"

  tags = {
    Name = "AWS-DevOps-Terraform-RDS-Secret"
  }
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id

  secret_string = jsonencode({
    username = aws_db_instance.postgres.username
    password = var.db_password
    host     = aws_db_instance.postgres.address
    port     = aws_db_instance.postgres.port
    database = aws_db_instance.postgres.db_name
  })
}