#!/bin/bash

# Complete S3 bucket fix for static website hosting

set -e

BUCKET_NAME="traveltimesapp.com"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔧 Complete S3 bucket configuration fix...${NC}"

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

echo -e "${YELLOW}📋 Fixing S3 bucket configuration...${NC}"

# 1. Enable static website hosting
echo -e "${BLUE}1. Enabling static website hosting...${NC}"
aws s3api put-bucket-website \
    --bucket $BUCKET_NAME \
    --website-configuration '{
        "IndexDocument": {
            "Suffix": "index.html"
        },
        "ErrorDocument": {
            "Key": "index.html"
        }
    }'

# 2. Remove all public access blocks
echo -e "${BLUE}2. Removing public access blocks...${NC}"
aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration '{
        "BlockPublicAcls": false,
        "IgnorePublicAcls": false,
        "BlockPublicPolicy": false,
        "RestrictPublicBuckets": false
    }'

# 3. Set bucket policy for public read access
echo -e "${BLUE}3. Setting bucket policy for public read access...${NC}"
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
                "Resource": "arn:aws:s3:::traveltimesapp.com/*"
            }
        ]
    }'

# 4. Verify the configuration
echo -e "${BLUE}4. Verifying configuration...${NC}"

echo -e "${YELLOW}📋 Checking website configuration:${NC}"
aws s3api get-bucket-website --bucket $BUCKET_NAME

echo -e "${YELLOW}📋 Checking public access blocks:${NC}"
aws s3api get-public-access-block --bucket $BUCKET_NAME

echo -e "${YELLOW}📋 Checking bucket policy:${NC}"
aws s3api get-bucket-policy --bucket $BUCKET_NAME

# 5. Test the website
echo -e "${BLUE}5. Testing website access...${NC}"
echo -e "${YELLOW}Testing S3 website endpoint...${NC}"
curl -I http://$BUCKET_NAME.s3-website-us-east-1.amazonaws.com

echo -e "${GREEN}✅ S3 bucket configuration complete!${NC}"
echo -e "${BLUE}📋 Test URLs:${NC}"
echo "• http://$BUCKET_NAME.s3-website-us-east-1.amazonaws.com (S3 direct)"
echo "• https://$BUCKET_NAME (CloudFront - after deployment)"
echo "• https://d2zz570ua3s1fi.cloudfront.net (CloudFront direct)"

echo -e "${YELLOW}⏳ CloudFront deployment is still in progress...${NC}"
echo -e "${BLUE}📋 To check CloudFront status:${NC}"
echo "aws cloudfront get-distribution --id E29CIMMJ1ZCXON --query 'Distribution.Status' --output text" 