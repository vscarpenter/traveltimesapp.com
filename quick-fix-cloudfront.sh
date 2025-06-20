#!/bin/bash

# Quick fix for CloudFront 403 error - disable WebACL temporarily

set -e

DISTRIBUTION_ID="E29CIMMJ1ZCXON"
ETAG="EJA210ZOCU9S2"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Quick fix for CloudFront 403 error...${NC}"

# Create minimal fix configuration
cat > cloudfront-quick-fix.json << 'EOF'
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

echo -e "${YELLOW}🔧 Applying CloudFront configuration fix...${NC}"
echo -e "${BLUE}Changes being applied:${NC}"
echo "✅ Set DefaultRootObject to 'index.html'"
echo "✅ Changed ViewerProtocolPolicy to 'redirect-to-https'"
echo "✅ Added custom error responses for 403/404"
echo "✅ Disabled WebACL (removed)"

# Apply the configuration
aws cloudfront update-distribution \
    --id $DISTRIBUTION_ID \
    --distribution-config file://cloudfront-quick-fix.json \
    --if-match $ETAG

echo -e "${GREEN}✅ CloudFront configuration updated successfully!${NC}"
echo -e "${YELLOW}⏳ Deployment in progress... (5-15 minutes)${NC}"
echo -e "${BLUE}📋 Test URLs after deployment:${NC}"
echo "• https://traveltimesapp.com"
echo "• https://d2zz570ua3s1fi.cloudfront.net"
echo "• http://traveltimesapp.com.s3-website-us-east-1.amazonaws.com (S3 direct)"

echo -e "${BLUE}📋 To check deployment status:${NC}"
echo "aws cloudfront get-distribution --id $DISTRIBUTION_ID --query 'Distribution.Status' --output text" 