resource "aws_iam_role_policy" "ecr_pull" {
  name = "AWS-DevOps-Terraform-ECR-Pull"
  role = aws_iam_role.ec2_ssm.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = [
          "arn:aws:ecr:ap-southeast-2:747764568654:repository/aws-devops-sample-backend",
          "arn:aws:ecr:ap-southeast-2:747764568654:repository/aws-devops-sample-frontend"
        ]
      }
    ]
  })
}
