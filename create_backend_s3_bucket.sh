#!/bin/bash

# Configuration
DEV_BUCKET="datacynth-dev-tfstate"
DEV_PROFILE="devadmin"
PROD_BUCKET="datacynth-prod-tfstate"
PROD_PROFILE="prodadmin"
REGION="us-west-2"

# Function to create a bucket and apply standard configurations
create_tfstate_bucket() {
  local BUCKET_NAME=$1
  local PROFILE=$2
  local REGION=$3

  echo "--- Processing bucket: $BUCKET_NAME ---"

  # Check if the bucket already exists
  if aws s3api head-bucket --bucket "$BUCKET_NAME" --profile "$PROFILE" 2>/dev/null; then
    echo "Bucket '$BUCKET_NAME' already exists. Skipping."
    return
  fi

  # Create the S3 bucket
  echo "Creating bucket '$BUCKET_NAME'"...
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$REGION" \
    --profile "$PROFILE" \
    --create-bucket-configuration LocationConstraint="$REGION"

  if [ $? -ne 0 ]; then
    echo "Error: Failed to create bucket '$BUCKET_NAME'. If you just deleted this bucket, you may need to wait a few minutes for the name to become available again."
    return 1
  fi

  # Block all public access
  echo "Applying public access block to '$BUCKET_NAME'..."
  aws s3api put-public-access-block \
    --bucket "$BUCKET_NAME" \
    --profile "$PROFILE" \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

  # Enable server-side encryption
  echo "Enabling server-side encryption for '$BUCKET_NAME'..."
  aws s3api put-bucket-encryption \
    --bucket "$BUCKET_NAME" \
    --profile "$PROFILE" \
    --server-side-encryption-configuration '{ "Rules": [ { "ApplyServerSideEncryptionByDefault": { "SSEAlgorithm": "AES256" } } ] }'

  echo "Bucket '$BUCKET_NAME' created and configured successfully."
}

# Create buckets
create_tfstate_bucket "$DEV_BUCKET" "$DEV_PROFILE" "$REGION"
create_tfstate_bucket "$PROD_BUCKET" "$PROD_PROFILE" "$REGION"

echo "--- Script finished. ---"
