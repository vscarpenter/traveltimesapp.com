#!/usr/bin/env bash
# Travel Times Milwaukee — deploy to S3 + CloudFront.
#
# Allowlist model: only the files named below ever reach the public bucket.
# A new file in the repo does NOT deploy until it is added to a list here.

set -euo pipefail
cd "$(dirname "$0")"

BUCKET="traveltimesapp.com"
DISTRIBUTION_ID="E29CIMMJ1ZCXON"

# Pages must always revalidate; CSS/JS are not fingerprinted, so browsers get
# a short cache while CloudFront keeps them until the deploy invalidation.
PAGES=(index.html privacy.html terms.html 404.html robots.txt sitemap.xml llms.txt)
CODE=(styles.css script.js)

command -v aws >/dev/null 2>&1 || { echo "error: aws CLI not installed" >&2; exit 1; }
aws sts get-caller-identity >/dev/null 2>&1 || { echo "error: AWS credentials not configured (run 'aws configure')" >&2; exit 1; }

echo "==> assets/ (images — 1-year cache)"
aws s3 sync assets/ "s3://$BUCKET/assets/" \
  --exclude ".DS_Store" \
  --cache-control "public,max-age=31536000" \
  --delete

echo "==> CSS/JS (1-hour browser cache, long CDN cache)"
for f in "${CODE[@]}"; do
  aws s3 cp "$f" "s3://$BUCKET/$f" --cache-control "public,max-age=3600,s-maxage=31536000"
done

echo "==> Pages (no-cache)"
for f in "${PAGES[@]}"; do
  aws s3 cp "$f" "s3://$BUCKET/$f" --cache-control "no-cache"
done

echo "==> CloudFront invalidation"
INVALIDATION_ID=$(aws cloudfront create-invalidation \
  --distribution-id "$DISTRIBUTION_ID" \
  --paths "/*" \
  --query 'Invalidation.Id' \
  --output text)

echo "Deployed. Invalidation $INVALIDATION_ID in progress — https://$BUCKET"
