terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = "fp-secure-api-gateway"
  region  = "asia-southeast2"
  zone    = "asia-southeast2-a"
}

resource "google_compute_instance" "e2_micro" {
  name         = "e2-micro-instance"
  machine_type = "e2-micro"
  zone         = "asia-southeast2-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      type  = "pd-standard"
      size  = 10
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }
}

output "instance_ip" {
  description = "The public IP address of the instance"
  value       = google_compute_instance.e2_micro.network_interface[0].access_config[0].nat_ip
}
