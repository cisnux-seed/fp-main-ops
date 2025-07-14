variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-southeast2"
}

variable "cluster_name" {
  description = "OpenShift cluster name"
  type        = string
  default     = "ocp-one-gate-payment"
}

variable "base_domain" {
  description = "Base domain for the cluster"
  type        = string
}

variable "master_count" {
  description = "Number of master nodes"
  type        = number
  default     = 1
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "zone_name" {
  description = "DNS zone name"
  type        = string
  default     = "openshift-zone"
}
