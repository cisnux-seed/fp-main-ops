#!/bin/bash
# Upload RHCOS image to GCP

PROJECT_ID="fp-secure-api-gateway"
RHCOS_VERSION="4.19"
REGION="asia-southeast2"

# Download RHCOS image
echo "Downloading RHCOS image..."
RHCOS_URL="https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.19/latest/rhcos-gcp.x86_64.tar.gz"
wget -O /tmp/rhcos-gcp.tar.gz $RHCOS_URL

BUCKET_NAME="${PROJECT_ID}-rhcos-images"

# Upload image to bucket
echo "Uploading RHCOS image to GCS..."
gsutil cp /tmp/rhcos-gcp.tar.gz gs://${BUCKET_NAME}/

# Create compute image
echo "Creating compute image..."
gcloud compute images create rhcos-419 \
    --source-uri=gs://${BUCKET_NAME}/rhcos-gcp.tar.gz \
    --family=rhcos \
    --project=$PROJECT_ID

echo "RHCOS image created successfully!"
rm /tmp/rhcos-gcp.tar.gz