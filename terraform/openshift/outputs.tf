# Cluster Configuration Outputs
output "cluster_name" {
  value       = var.cluster_name
  description = "OpenShift cluster name"
}

output "base_domain" {
  value       = var.base_domain
  description = "Base domain for the OpenShift cluster"
}

output "project_id" {
  value       = var.project_id
  description = "GCP project ID"
}

output "region" {
  value       = var.region
  description = "GCP region for the cluster"
}

# Network Infrastructure Outputs
output "network_name" {
  value       = google_compute_network.openshift_network.name
  description = "VPC network name for the cluster"
}

# Load Balancer Outputs

output "api_internal_ip" {
  value       = google_compute_forwarding_rule.api_internal.ip_address
  description = "Internal API load balancer IP address"
}

# DNS Outputs
output "dns_zone_name" {
  value       = google_dns_managed_zone.openshift_zone.name
  description = "DNS managed zone name"
}

output "dns_zone_name_servers" {
  value       = google_dns_managed_zone.openshift_zone.name_servers
  description = "DNS zone name servers for domain delegation"
}

output "ignition_bucket_name" {
  value       = google_storage_bucket.ignition_bucket.name
  description = "Storage bucket for ignition configuration files"
}

output "ignition_bucket_url" {
  value       = google_storage_bucket.ignition_bucket.url
  description = "Storage bucket URL for ignition files"
}