# VPC Network
resource "google_compute_network" "openshift_network" {
  name                    = "${var.cluster_name}-network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Control Plane Subnet (Master nodes)
resource "google_compute_subnetwork" "master_subnet" {
  name                     = "${var.cluster_name}-master-subnet"
  ip_cidr_range           = "10.0.0.0/19"     # 8,192 IPs
  network                 = google_compute_network.openshift_network.id
  region                  = var.region
  private_ip_google_access = true
  
  # Pod and Service IP ranges for cluster networking
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.128.0.0/14"  # Supports ~1M pod IPs
  }
  
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "172.30.0.0/16"  # OpenShift default service range
  }
}

# Compute Subnet (Worker nodes)
resource "google_compute_subnetwork" "worker_subnet" {
  name                     = "${var.cluster_name}-worker-subnet"
  ip_cidr_range           = "10.0.32.0/19"    # 8,192 IPs
  network                 = google_compute_network.openshift_network.id
  region                  = var.region
  private_ip_google_access = true
}

# Cloud Router for NAT Gateway
resource "google_compute_router" "cluster_router" {
  name    = "${var.cluster_name}-router"
  network = google_compute_network.openshift_network.id
  region  = var.region
}

# Cloud NAT for Outbound Internet Access
resource "google_compute_router_nat" "cluster_nat" {
  name   = "${var.cluster_name}-nat"
  router = google_compute_router.cluster_router.name
  region = var.region
  
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Firewall Rules for OpenShift
resource "google_compute_firewall" "cluster_internal" {
  name    = "${var.cluster_name}-internal"
  network = google_compute_network.openshift_network.name

  allow {
    protocol = "tcp"
  }
  
  allow {
    protocol = "udp"
  }
  
  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "10.0.0.0/19",    # Control plane subnet
    "10.0.32.0/19",   # Compute subnet
    "10.128.0.0/14",  # Pod IPs
    "172.30.0.0/16"   # Service IPs
  ]
  
  target_tags = ["${var.cluster_name}-cluster"]
}

resource "google_compute_firewall" "cluster_ssh" {
  name    = "${var.cluster_name}-ssh"
  network = google_compute_network.openshift_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]  # Restrict this to your IP ranges in production
  target_tags   = ["${var.cluster_name}-cluster"]
}

resource "google_compute_firewall" "cluster_api" {
  name    = "${var.cluster_name}-api"
  network = google_compute_network.openshift_network.name

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.cluster_name}-cluster"]
}

resource "google_compute_firewall" "cluster_ingress" {
  name    = "${var.cluster_name}-ingress"
  network = google_compute_network.openshift_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.cluster_name}-cluster"]
}