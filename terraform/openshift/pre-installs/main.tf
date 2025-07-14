# Resources that must exist before running openshift-install

# Image bucket for RHCOS
resource "google_storage_bucket" "images" {
  name     = "${var.project_id}-rhcos-images"
  location = var.region
  project = var.project_id
  force_destroy = true
}

# Installation bucket
resource "google_storage_bucket" "installation" {
  name     = "${var.project_id}-${var.cluster_name}-installation"
  location = var.region
  project = var.project_id
}

# Bootstrap ignition URL will be created by installer
output "bootstrap_ignition_bucket" {
  value = google_storage_bucket.installation.url
}

# Ensure service APIs are enabled
resource "google_project_service" "required_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "storage.googleapis.com",
    "dns.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "container.googleapis.com",
  ])
  
  service = each.value
  disable_on_destroy = false
  project = var.project_id
}