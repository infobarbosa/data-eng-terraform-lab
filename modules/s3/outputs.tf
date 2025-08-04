output "dataeng_bucket" {
    description = "O nome do bucket S3"
    value = aws_s3_bucket.dataeng_bucket.bucket
}

output "dataeng_bucket_arn" {
    description = "O ARN do bucket S3"
    value = aws_s3_bucket.dataeng_bucket.arn
}
