variable "aws_region" {
  description = "AWS region for the S3 bucket and IAM resources."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique name for the private portfolio S3 bucket."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be a valid lowercase S3 bucket name between 3 and 63 characters."
  }
}

variable "deploy_user_name" {
  description = "Name of the dedicated IAM user that receives site deployment permissions."
  type        = string
  default     = "portfolio-deploy"
}
