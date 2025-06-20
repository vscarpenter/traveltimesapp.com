#!/bin/bash

# Fix CloudFront Distribution Configuration for Travel Times Milwaukee

set -e

# Configuration
DISTRIBUTION_ID="E29CIMMJ1ZCXON"
ETAG="EJA210ZOCU9S2"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔧 Fixing CloudFront distribution configuration...${NC}"

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

echo -e "${YELLOW}📋 Issues found in CloudFront configuration:${NC}"
echo "1. DefaultRootObject is empty (should be 'index.html')"
echo "2. ViewerProtocolPolicy is 'allow-all' (should be 'redirect-to-https')"
echo "3. No custom error responses for 403/404 errors"
echo "4. WebACL is enabled (may be blocking access)"

echo -e "${YELLOW}🔧 Creating updated CloudFront configuration...${NC}"

# Create updated configuration
cat > cloudfront-updated-config.json << 'EOF'
{
    "CallerReference": "73594b34-5eac-4d18-8a20-23dacdf57be8",
    "Aliases": {
        "Quantity": 2,
        "Items": [
            "www.traveltimesapp.com",
            "traveltimesapp.com"
        ]
    },
    "DefaultRootObject": "index.html",
    "Origins": {
        "Quantity": 1,
        "Items": [
            {
                "Id": "traveltimesapp.com.s3.us-east-1.amazonaws.com-mc3kc0dezbq",
                "DomainName": "traveltimesapp.com.s3-website-us-east-1.amazonaws.com",
                "OriginPath": "",
                "CustomHeaders": {
                    "Quantity": 0
                },
                "CustomOriginConfig": {
                    "HTTPPort": 80,
                    "HTTPSPort": 443,
                    "OriginProtocolPolicy": "http-only",
                    "OriginSslProtocols": {
                        "Quantity": 4,
                        "Items": [
                            "SSLv3",
                            "TLSv1",
                            "TLSv1.1",
                            "TLSv1.2"
                        ]
                    },
                    "OriginReadTimeout": 30,
                    "OriginKeepaliveTimeout": 5
                },
                "ConnectionAttempts": 3,
                "ConnectionTimeout": 10,
                "OriginShield": {
                    "Enabled": false
                },
                "OriginAccessControlId": ""
            }
        ]
    },
    "OriginGroups": {
        "Quantity": 0
    },
    "DefaultCacheBehavior": {
        "TargetOriginId": "traveltimesapp.com.s3.us-east-1.amazonaws.com-mc3kc0dezbq",
        "TrustedSigners": {
            "Enabled": false,
            "Quantity": 0
        },
        "TrustedKeyGroups": {
            "Enabled": false,
            "Quantity": 0
        },
        "ViewerProtocolPolicy": "redirect-to-https",
        "AllowedMethods": {
            "Quantity": 2,
            "Items": [
                "HEAD",
                "GET"
            ],
            "CachedMethods": {
                "Quantity": 2,
                "Items": [
                    "HEAD",
                    "GET"
                ]
            }
        },
        "SmoothStreaming": false,
        "Compress": true,
        "LambdaFunctionAssociations": {
            "Quantity": 0
        },
        "FunctionAssociations": {
            "Quantity": 0
        },
        "FieldLevelEncryptionId": "",
        "CachePolicyId": "658327ea-f89d-4fab-a63d-7e88639e58f6",
        "GrpcConfig": {
            "Enabled": false
        }
    },
    "CacheBehaviors": {
        "Quantity": 0
    },
    "CustomErrorResponses": {
        "Quantity": 2,
        "Items": [
            {
                "ErrorCode": 403,
                "ResponsePagePath": "/index.html",
                "ResponseCode": "200",
                "ErrorCachingMinTTL": 0
            },
            {
                "ErrorCode": 404,
                "ResponsePagePath": "/index.html",
                "ResponseCode": "200",
                "ErrorCachingMinTTL": 0
            }
        ]
    },
    "Comment": "",
    "Logging": {
        "Enabled": false,
        "IncludeCookies": false,
        "Bucket": "",
        "Prefix": ""
    },
    "PriceClass": "PriceClass_All",
    "Enabled": true,
    "ViewerCertificate": {
        "CloudFrontDefaultCertificate": false,
        "ACMCertificateArn": "arn:aws:acm:us-east-1:710603110067:certificate/23accd8e-c3e7-4c36-b38f-7ae0ba9bb9a8",
        "SSLSupportMethod": "sni-only",
        "MinimumProtocolVersion": "TLSv1.2_2021",
        "Certificate": "arn:aws:acm:us-east-1:710603110067:certificate/23accd8e-c3e7-4c36-b38f-7ae0ba9bb9a8",
        "CertificateSource": "acm"
    },
    "Restrictions": {
        "GeoRestriction": {
            "RestrictionType": "none",
            "Quantity": 0
        }
    },
    "WebACLId": "",
    "HttpVersion": "http2",
    "IsIPV6Enabled": true,
    "ContinuousDeploymentPolicyId": "",
    "Staging": false
}
EOF

echo -e "${GREEN}✅ Updated configuration created!${NC}"

echo -e "${YELLOW}⚠️  IMPORTANT: Before updating CloudFront, please:${NC}"
echo "1. Check if the WebACL is blocking legitimate traffic"
echo "2. Consider temporarily disabling the WebACL to test"
echo "3. The configuration above removes the WebACL (set to empty string)"

echo -e "${BLUE}📋 To apply the fix:${NC}"
echo "1. Review the cloudfront-updated-config.json file"
echo "2. Run: aws cloudfront update-distribution --id $DISTRIBUTION_ID --distribution-config file://cloudfront-updated-config.json --if-match [ETAG]"
echo "3. Wait for deployment (5-15 minutes)"

echo -e "${YELLOW}🔍 To check current ETAG:${NC}"
echo "aws cloudfront get-distribution --id $DISTRIBUTION_ID --query 'ETag' --output text"

echo -e "${BLUE}📋 Alternative quick fixes to try:${NC}"
echo "1. Temporarily disable WebACL in CloudFront console"
echo "2. Add index.html as Default Root Object"
echo "3. Configure error pages for 403/404 → /index.html" 