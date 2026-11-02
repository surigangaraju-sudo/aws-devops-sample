terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
  environment = var.environment
  common_tags = local.common_tags
}

data "aws_caller_identity" "current" {}