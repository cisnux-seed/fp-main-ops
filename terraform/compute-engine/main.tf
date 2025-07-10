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

resource "google_compute_instance" "e2_medium" {
  name         = "e2-medium-instance"
  machine_type = "e2-medium"
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

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("~/.ssh/google_compute_engine.pub")}"
  }

  tags = ["ssh-access"]
}

variable "ssh_user" {
  description = "SSH username for the instance"
  type        = string
  default     = "cisnux"
}

output "instance_ip" {
  description = "The public IP address of the instance"
  value       = google_compute_instance.e2_medium.network_interface[0].access_config[0].nat_ip
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/google_compute_engine ${var.ssh_user}@${google_compute_instance.e2_medium.network_interface[0].access_config[0].nat_ip}"
}