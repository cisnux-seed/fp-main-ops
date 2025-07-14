# DNS Managed Zone (only if you need to create it)
resource "google_dns_managed_zone" "openshift_zone" {
  name        = var.zone_name
  dns_name    = "${var.base_domain}."
  description = "Managed Zone for OpenShift base domain"
  visibility  = "public"
}

# API Internal DNS Record (for internal cluster communication)
resource "google_dns_record_set" "api_internal" {
  name         = "api-int.${var.cluster_name}.${var.base_domain}."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.openshift_zone.name
  rrdatas      = [google_compute_forwarding_rule.api_internal.ip_address]
}

# Note: Apps wildcard DNS is now managed automatically by OpenShift's ingress operator
# when using cloud-provider integration. Manual DNS records are only needed for 
# air-gapped or restricted network installations.