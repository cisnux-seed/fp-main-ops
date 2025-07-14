# Available Zones Data Source
data "google_compute_zones" "available" {
  region = var.region
}

# Health Checks (Still Required)
resource "google_compute_region_health_check" "api_internal" {
  name   = "${var.cluster_name}-api-internal-health"
  region = var.region

  tcp_health_check {
    port = 6443
  }

  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3
}

resource "google_compute_health_check" "api_external" {
  name = "${var.cluster_name}-api-external-health"

  tcp_health_check {
    port = 6443
  }

  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3
}

# External API Load Balancer (Still Required for Control Plane)
resource "google_compute_global_address" "api_external" {
  name = "${var.cluster_name}-api-external"
}

resource "google_compute_backend_service" "api_external" {
  name                  = "${var.cluster_name}-api-external"
  protocol              = "TCP"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.api_external.id]
  timeout_sec           = 10

  # Note: Backends will be populated by OpenShift's cloud-controller-manager
  # No need for instance groups or placeholder instances
}

resource "google_compute_target_tcp_proxy" "api_external" {
  name            = "${var.cluster_name}-api-tcp-proxy"
  backend_service = google_compute_backend_service.api_external.id
}

resource "google_compute_global_forwarding_rule" "api_external" {
  name       = "${var.cluster_name}-api-external"
  target     = google_compute_target_tcp_proxy.api_external.id
  port_range = "6443"
  ip_address = google_compute_global_address.api_external.address
}

# Internal API Load Balancer (Simplified)
resource "google_compute_region_backend_service" "api_internal" {
  name                  = "${var.cluster_name}-api-internal"
  region                = var.region
  protocol              = "TCP"
  load_balancing_scheme = "INTERNAL"
  health_checks         = [google_compute_region_health_check.api_internal.id]
  timeout_sec           = 10

  # Note: Backends will be populated by OpenShift's cloud-controller-manager
}

resource "google_compute_forwarding_rule" "api_internal" {
  name                  = "${var.cluster_name}-api-internal"
  region                = var.region
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.api_internal.id
  subnetwork            = google_compute_subnetwork.master_subnet.id
  ports                 = ["6443"]
}

# Note: The following are NO LONGER NEEDED in OpenShift 4.19:
# - Instance groups (managed by Machine API)
# - Placeholder instances (not required)
# - Router/Ingress load balancers (managed by cloud-controller-manager)
# - MCS load balancer (handled internally)
# - Manual backend population (done automatically)