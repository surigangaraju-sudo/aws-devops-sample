resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

tags = {
  Name        = "Terraform DevOps Lab"
  Environment = var.environment
}
}