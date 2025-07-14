variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "OpenShift cluster name"
  type        = string
  default     = "ocp-one-gate-payment"
}

variable "base_domain" {
  description = "Base domain for OpenShift cluster"
  type        = string
}
