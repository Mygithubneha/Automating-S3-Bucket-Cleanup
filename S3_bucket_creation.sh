#!/usr/bin/env sh

# Define the region and the bucket name as variables
BUCKET_NAME="aws-bucket-147-$(date +%s)"  # Append timestamp to make the name unique
REGION="ap-south-1"

# Create the S3 bucket
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION

# Enable versioning on the bucket
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

# Output the bucket name
echo "S3 Bucket $BUCKET_NAME created with versioning enabled."
