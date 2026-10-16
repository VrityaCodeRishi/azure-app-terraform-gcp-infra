variable "project_id" {
  description = "Google Cloud project ID in which to create GKE resources."
  type        = string
}

variable "region" {
  description = "Google Cloud region for the regional GKE cluster."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for the cluster and node service account names."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,35}[a-z0-9]$", var.name_prefix))
    error_message = "name_prefix must be 3-37 lowercase letters, numbers, or hyphens and start with a letter."
  }
}

variable "labels" {
  description = "Labels applied to the cluster and node pool."
  type        = map(string)
  default     = {}
}

variable "network_id" {
  description = "Fully qualified ID of the VPC network used by GKE."
  type        = string
}

variable "subnetwork_id" {
  description = "Fully qualified ID of the subnetwork used by GKE."
  type        = string
}

variable "pods_secondary_range_name" {
  description = "Subnetwork secondary range name allocated to GKE Pods."
  type        = string
}

variable "services_secondary_range_name" {
  description = "Subnetwork secondary range name allocated to Kubernetes Services."
  type        = string
}

variable "node_machine_type" {
  description = "Compute Engine machine type for the GKE node pool."
  type        = string
}

variable "node_disk_size_gb" {
  description = "Boot disk size for each GKE node."
  type        = number

  validation {
    condition     = var.node_disk_size_gb >= 30
    error_message = "node_disk_size_gb must be at least 30 GB."
  }
}

variable "node_pool_total_min_nodes" {
  description = "Minimum node count across all zones in the regional node pool."
  type        = number

  validation {
    condition     = var.node_pool_total_min_nodes >= 1
    error_message = "node_pool_total_min_nodes must be at least 1."
  }
}

variable "node_pool_total_max_nodes" {
  description = "Maximum node count across all zones in the regional node pool."
  type        = number

  validation {
    condition     = var.node_pool_total_max_nodes >= var.node_pool_total_min_nodes
    error_message = "node_pool_total_max_nodes must be greater than or equal to node_pool_total_min_nodes."
  }
}

variable "release_channel" {
  description = "GKE release channel."
  type        = string

  validation {
    condition     = contains(["RAPID", "REGULAR", "STABLE", "EXTENDED"], var.release_channel)
    error_message = "release_channel must be RAPID, REGULAR, STABLE, or EXTENDED."
  }
}

variable "maintenance_start_time" {
  description = "Daily GKE maintenance window start in UTC using HH:MM format."
  type        = string

  validation {
    condition     = can(regex("^(?:[01][0-9]|2[0-3]):[0-5][0-9]$", var.maintenance_start_time))
    error_message = "maintenance_start_time must use 24-hour HH:MM format."
  }
}

variable "deletion_protection" {
  description = "Whether Terraform should prevent deletion of the GKE cluster."
  type        = bool
}
