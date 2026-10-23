output "bucket_name" {
  description = "Name of the S3 bucket created by this module"
  value       = aws_s3_bucket.this.bucket
}