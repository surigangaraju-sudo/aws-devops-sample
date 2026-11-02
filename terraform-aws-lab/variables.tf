variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "bucket_name" {
  description = "Terraform lab S3 bucket name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}