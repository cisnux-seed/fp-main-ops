# Storage bucket for ignition files
resource "google_storage_bucket" "ignition_bucket" {
  name                        = "${var.project_id}-${var.cluster_name}-ignition"
  location                    = var.region
  uniform_bucket_level_access = true
  
  # Auto-delete ignition files after bootstrap completion
  lifecycle_rule {
    condition {
      age = 7  # Keep for a week for troubleshooting
    }
    action {
      type = "Delete"
    }
  }
  
  # Public read access for ignition files during bootstrap
  lifecycle_rule {
    condition {
      age = 0
    }
    action {
      type = "SetStorageClass"
      storage_class = "STANDARD"
    }
  }
}

# Bucket IAM for public read access (required for ignition)
resource "google_storage_bucket_iam_member" "ignition_public_read" {
  bucket = google_storage_bucket.ignition_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Note: RHCOS image should be uploaded manually before cluster installation
# You can upload using: gcloud compute images create rhcos-xxx --source-uri gs://bucket/rhcos.tar.gz --family rhcos