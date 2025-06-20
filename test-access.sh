#!/bin/bash

# Test access to Travel Times Milwaukee website

echo "Testing S3 website access..."

# The S3 website endpoint should be:
S3_ENDPOINT="http://traveltimesapp.com.s3-website-us-east-1.amazonaws.com"

echo "Testing S3 endpoint: $S3_ENDPOINT"

# Test with curl
if command -v curl &> /dev/null; then
    echo "Testing with curl..."
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$S3_ENDPOINT")
    echo "HTTP Status Code: $HTTP_CODE"
    
    if [ "$HTTP_CODE" = "200" ]; then
        echo "✅ S3 website is accessible!"
    else
        echo "❌ S3 website returned status code: $HTTP_CODE"
    fi
else
    echo "curl not available, please test manually:"
    echo "Visit: $S3_ENDPOINT"
fi

echo ""
echo "Testing CloudFront endpoint: https://traveltimesapp.com"
echo "Please test manually by visiting: https://traveltimesapp.com"

echo ""
echo "Troubleshooting steps:"
echo "1. If S3 works but CloudFront doesn't:"
echo "   - Check CloudFront distribution settings"
echo "   - Verify origin is set to S3 website endpoint"
echo "   - Check if SSL certificate is valid"
echo ""
echo "2. If neither works:"
echo "   - Check DNS settings for traveltimesapp.com"
echo "   - Verify CloudFront distribution is deployed"
echo "   - Check CloudFront error pages configuration" 