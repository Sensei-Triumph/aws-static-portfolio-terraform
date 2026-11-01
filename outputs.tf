output "bucket_name" {
  description = "Private S3 bucket receiving the portfolio site."
  value       = aws_s3_bucket.site.id
}

output "distribution_id" {
  description = "CloudFront distribution ID used for cache invalidations."
  value       = aws_cloudfront_distribution.site.id
}

output "site_url" {
  description = "HTTPS URL for the portfolio site."
  value       = "https://${aws_cloudfront_distribution.site.domain_name}"
}

output "deploy_user_name" {
  description = "IAM user to configure with a named AWS CLI profile for deployment."
  value       = aws_iam_user.deploy.name
}
