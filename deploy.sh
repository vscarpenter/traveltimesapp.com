#!/bin/bash

# Travel Times Milwaukee Landing Page Deployment Script
# This script deploys the static website to existing AWS S3 bucket and CloudFront

set -e

# Configuration
BUCKET_NAME="traveltimesapp.com"
REGION="us-east-1"
CLOUDFRONT_DISTRIBUTION_ID="E29CIMMJ1ZCXON"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting deployment of Travel Times Milwaukee landing page...${NC}"

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

# Sync files to S3
echo -e "${YELLOW}📤 Uploading files to S3...${NC}"
aws s3 sync . s3://$BUCKET_NAME \
    --exclude "*.sh" \
    --exclude ".git/*" \
    --exclude "README.md" \
    --exclude "deploy.sh" \
    --cache-control "max-age=31536000,public" \
    --delete

# Set cache control for HTML files
echo -e "${YELLOW}⚙️ Setting cache control for HTML files...${NC}"
aws s3 cp s3://$BUCKET_NAME/index.html s3://$BUCKET_NAME/index.html \
    --cache-control "no-cache,no-store,must-revalidate" \
    --content-type "text/html"

aws s3 cp s3://$BUCKET_NAME/privacy.html s3://$BUCKET_NAME/privacy.html \
    --cache-control "no-cache,no-store,must-revalidate" \
    --content-type "text/html"

aws s3 cp s3://$BUCKET_NAME/terms.html s3://$BUCKET_NAME/terms.html \
    --cache-control "no-cache,no-store,must-revalidate" \
    --content-type "text/html"

# Set cache control for robots.txt
aws s3 cp s3://$BUCKET_NAME/robots.txt s3://$BUCKET_NAME/robots.txt \
    --cache-control "no-cache,no-store,must-revalidate" \
    --content-type "text/plain"

echo -e "${GREEN}✅ Files uploaded successfully!${NC}"

# CloudFront invalidation (if distribution ID is provided)
if [ -n "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
    echo -e "${YELLOW}🔄 Invalidating CloudFront cache...${NC}"
    aws cloudfront create-invalidation \
        --distribution-id $CLOUDFRONT_DISTRIBUTION_ID \
        --paths "/*"
    echo -e "${GREEN}✅ CloudFront cache invalidation initiated!${NC}"
else
    echo -e "${BLUE}ℹ️  To invalidate CloudFront cache, set CLOUDFRONT_DISTRIBUTION_ID in the script${NC}"
    echo -e "${BLUE}ℹ️  Or run manually: aws cloudfront create-invalidation --distribution-id YOUR_DISTRIBUTION_ID --paths '/*'${NC}"
fi

echo -e "${GREEN}🎉 Deployment completed!${NC}"
echo -e "${YELLOW}Your website is now available at: https://$BUCKET_NAME${NC}"
