resource "aws_iam_role_policy" "secrets_manager" {
  name = "AWS-DevOps-Terraform-SecretsManager"
  role = aws_iam_role.ec2_ssm.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "secretsmanager:GetSecretValue"
      ]

      Resource = "arn:aws:secretsmanager:ap-southeast-2:747764568654:secret:aws-devops-terraform/rds-*"
    }]
  })
}