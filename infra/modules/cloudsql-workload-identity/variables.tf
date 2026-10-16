variable "project_id" {
  description = "Google Cloud project containing the GKE and Cloud SQL resources."
  type        = string
}

variable "google_service_account_id" {
  description = "Account ID for the application Google service account."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.google_service_account_id))
    error_message = "google_service_account_id must be 6-30 lowercase letters, numbers, or hyphens, start with a letter, and end with a letter or number."
  }
}

variable "google_service_account_display_name" {
  description = "Human-readable name for the application Google service account."
  type        = string
  default     = "Application Cloud SQL identity"
}

variable "workload_identity_pool" {
  description = "GKE Workload Identity pool, normally PROJECT_ID.svc.id.goog."
  type        = string
}

variable "kubernetes_namespace" {
  description = "Namespace containing the Kubernetes service account used by the application."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.kubernetes_namespace))
    error_message = "kubernetes_namespace must be a valid DNS label."
  }
}

variable "kubernetes_service_account" {
  description = "Kubernetes service account used by the application Pods."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.kubernetes_service_account))
    error_message = "kubernetes_service_account must be a valid DNS label."
  }
}

variable "cloudsql_instance_name" {
  description = "Cloud SQL instance on which to create the IAM database user."
  type        = string
}
