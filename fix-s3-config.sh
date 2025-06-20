#!/bin/bash

# Fix S3 Bucket Configuration for Travel Times Milwaukee
# This script configures the S3 bucket for static website hosting

set -e

# Configuration
BUCKET_NAME="traveltimesapp.com"
REGION="us-east-1"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔧 Fixing S3 bucket configuration for Travel Times Milwaukee...${NC}"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if user is authenticated
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}❌ AWS credentials not configured. Please run 'aws configure' first.${NC}"
    exit 1
fi

# Check if bucket exists
echo -e "${YELLOW}🔍 Checking if S3 bucket exists...${NC}"
if ! aws s3api head-bucket --bucket $BUCKET_NAME 2>/dev/null; then
    echo -e "${RED}❌ Bucket '$BUCKET_NAME' does not exist. Please create it first in the AWS console.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Bucket '$BUCKET_NAME' found!${NC}"

# Configure bucket for static website hosting
echo -e "${YELLOW}🌐 Configuring bucket for static website hosting...${NC}"
aws s3api put-bucket-website \
    --bucket $BUCKET_NAME \
    --website-configuration '{
        "IndexDocument": {"Suffix": "index.html"},
        "ErrorDocument": {"Key": "index.html"}
    }'

echo -e "${GREEN}✅ Static website hosting configured!${NC}"

# Configure bucket policy for public read access
echo -e "${YELLOW}🔓 Configuring bucket policy for public access...${NC}"
aws s3api put-bucket-policy \
    --bucket $BUCKET_NAME \
    --policy '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "PublicReadGetObject",
                "Effect": "Allow",
                "Principal": "*",
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::'$BUCKET_NAME'/*"
            }
        ]
    }'

echo -e "${GREEN}✅ Bucket policy configured!${NC}"

# Remove public access block if it exists
echo -e "${YELLOW}🔓 Checking and removing public access blocks...${NC}"
aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

echo -e "${GREEN}✅ Public access blocks removed!${NC}"

# Set proper content types for files
echo -e "${YELLOW}📝 Setting proper content types...${NC}"

# HTML files
aws s3 cp s3://$BUCKET_NAME/index.html s3://$BUCKET_NAME/index.html \
    --cache-control "no-cache,no-store,must-revalidate" \
    --content-type "text/html" \
    --metadata-directive REPLACE

aws s3 cp s3://$BUCKET_NAME/privacy.html s3://$BUCKET_NAME/privacy.html \
    --cache-control "no-cache,no-store,must-revalidate" \
    --content-type "text/html" \
    --metadata-directive REPLACE

aws s3 cp s3://$BUCKET_NAME/terms.html s3://$BUCKET_NAME/terms.html \
    --cache-control "no-cache,no-store,must-revalidate" \
    --content-type "text/html" \
    --metadata-directive REPLACE

# CSS and JS files
aws s3 cp s3://$BUCKET_NAME/styles.css s3://$BUCKET_NAME/styles.css \
    --cache-control "max-age=31536000,public" \
    --content-type "text/css" \
    --metadata-directive REPLACE

aws s3 cp s3://$BUCKET_NAME/script.js s3://$BUCKET_NAME/script.js \
    --cache-control "max-age=31536000,public" \
    --content-type "application/javascript" \
    --metadata-directive REPLACE

# Other files
aws s3 cp s3://$BUCKET_NAME/robots.txt s3://$BUCKET_NAME/robots.txt \
    --cache-control "no-cache,no-store,must-revalidate" \
    --content-type "text/plain" \
    --metadata-directive REPLACE

# Image files
aws s3 cp s3://$BUCKET_NAME/assets/tt-1024.png s3://$BUCKET_NAME/assets/tt-1024.png \
    --cache-control "max-age=31536000,public" \
    --content-type "image/png" \
    --metadata-directive REPLACE

aws s3 cp s3://$BUCKET_NAME/assets/logo.svg s3://$BUCKET_NAME/assets/logo.svg \
    --cache-control "max-age=31536000,public" \
    --content-type "image/svg+xml" \
    --metadata-directive REPLACE

echo -e "${GREEN}✅ Content types configured!${NC}"

# Get website endpoint
echo -e "${YELLOW}🌐 Getting website endpoint...${NC}"
WEBSITE_ENDPOINT=$(aws s3api get-bucket-website --bucket $BUCKET_NAME --query 'WebsiteEndpoint' --output text)

echo -e "${GREEN}🎉 S3 bucket configuration completed!${NC}"
echo -e "${YELLOW}Your website should now be accessible at:${NC}"
echo -e "${BLUE}http://$WEBSITE_ENDPOINT${NC}"
echo -e "${YELLOW}CloudFront URL: https://$BUCKET_NAME${NC}"

echo -e "${BLUE}📋 Next steps:${NC}"
echo "1. Check if the website is accessible at the S3 endpoint above"
echo "2. If S3 works but CloudFront doesn't, check your CloudFront distribution settings"
echo "3. Ensure your domain DNS points to the CloudFront distribution"
echo "4. Verify SSL certificate is properly configured in CloudFront" 