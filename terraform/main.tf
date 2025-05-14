# To host a static website using s3 and cloudfront

provider "aws" {
  region     = "us-east-1 or your preffered region"
  access_key = "your access key"
  secret_key = "your secret access key"
}

resource "aws_s3_bucket" "bucket_refr_name" {
  bucket        = "random unique bucket name"
  force_destroy = true # allows destruction
}

resource "aws_s3_bucket_public_access_block" "allow_public" { #allowing public access
  bucket = aws_s3_bucket.bucket_refr_name.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" { #adding policy
  bucket = aws_s3_bucket.bucket_refr_name.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::your-site-name/*"
      }
    ]
  })
}

###########################
# Upload Files to S3, make sure the files are at the same place as the main.tf file
###########################

resource "aws_s3_object" "upload_index" {
  bucket       = aws_s3_bucket.bucket_refr_name.id
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
  acl          = "public-read"
}

resource "aws_s3_object" "upload_image" {
  bucket       = aws_s3_bucket.bucket_refr_name.id
  key          = "output.jpg"
  source       = "${path.module}/output.jpg"
  content_type = "image/jpeg"
  acl          = "public-read"
}

###########################
# CloudFront Distribution
###########################

resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "S3-OAC"
  description                       = "Origin access control for S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "no-override"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = "${aws_s3_bucket.bucket_refr_name.bucket}.s3.amazonaws.com"
    origin_id   = "S3Origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "PublicCDN"
  }
}

