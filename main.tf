terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "access_key" {
  description = "AWS access key"
  type        = string
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "environment" {
  description = "Environment type (dev or prod)"
  type        = string
  default     = "dev"
}

variable "bucket_count" {
  description = "Number of AWS S3 buckets to create"
  type        = number
  default     = 2  # Default to 2 buckets for dev environment
}

locals {
  bucket_names = [for idx in range(var.bucket_count) : "${var.environment}-example-bucket-${idx + 1}"]
}

resource "aws_s3_bucket" "example" {
  for_each = { for idx, name in local.bucket_names : idx => name }

  bucket = each.value

  tags = {
    Name        = each.value
    Environment = var.environment
  }
}
