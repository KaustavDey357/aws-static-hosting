# AWS Static Website Hosting with S3 + CloudFront  
> Host a secure, scalable, and fast static website using AWS S3 and CloudFront

## Overview  
This project demonstrates how to host a static frontend website using **Amazon S3** for storage and **CloudFront** as the global content delivery network (CDN). The website includes HTTPS support, versioned deployments, and optional custom domain configuration.

This is a perfect deployment setup for frontend applications like React, Vue, or static HTML/CSS sites.

---

## Tech Stack  
- **AWS S3** – Object storage to host static website files  
- **AWS CloudFront** – CDN to cache and serve content globally with HTTPS  
- **AWS Route 53** *(optional)* – For custom domain + SSL  
- **Terraform** *(optional)* – For automated infrastructure  
- **GitHub** – Code and version control

---

## Architecture Diagram

![Architecture](./s3-cloudfront-diagram.png)

1. Static files are uploaded to **S3** with public read or OAI policy  
2. **CloudFront** serves content via edge locations (HTTPS + cache)  
3. *(Optional)* Route 53 links your domain to CloudFront with SSL

---

## Project Structure

project-root/
├── site/ # Your static files (HTML, CSS, JS)
├── terraform/ # Terraform files (optional IaC)
├── screenshots/ # Demo screenshots
├── .gitignore
└── README.md


---

## Setup Instructions

### Option 1: Manual Deployment (AWS Console)

1. **Create S3 Bucket**  
   - Name: `your-site-name`  
   - Disable Block All Public Access  
   - Enable Static Website Hosting  
   - Note the endpoint URL

2. **Upload Files**  
   - Go to "Objects" → "Upload" your `index.html`, `style.css`, etc.

3. **Set Bucket Policy**
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "PublicReadGetObject",
         "Effect": "Allow",
         "Principal": "*",
         "Action": "s3:GetObject",
         "Resource": "arn:aws:s3:::your-site-name/*"
       }
     ]
   }
Create CloudFront Distribution

Origin Domain: your S3 bucket website endpoint

Enable caching, set default root object as index.html

Optional: Add custom domain + SSL certificate (ACM)

Option 2: Deploy Using Terraform (Optional)
You can automate all of the above using Terraform.

cd terraform/
terraform init
terraform apply
This will:

Create S3 bucket with correct settings

Upload static site files

Set CloudFront as CDN

(Optional) Configure Route 53 for custom domain

Custom Domain with HTTPS (Optional)
Buy Domain via Route 53 or use existing

Request SSL cert in AWS Certificate Manager

Attach domain + SSL to CloudFront

Create A/AAAA records in Route 53 pointing to CloudFront

Screenshots
S3 Hosting Screenshot
CloudFront Setup

Live Demo
View Live Site

Useful Commands (CLI)
# Upload site manually
aws s3 sync ./site s3://your-bucket-name --acl public-read

# Invalidate CloudFront cache (after deploy)
aws cloudfront create-invalidation \
  --distribution-id YOUR_ID \
  --paths "/*"
Author
Your Name

GitHub: @deykaustav357

LinkedIn: linkedin.com/in/deykaustav357

Portfolio: deykaustav357.github.io
