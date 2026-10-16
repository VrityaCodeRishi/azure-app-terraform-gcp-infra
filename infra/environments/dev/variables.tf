variable "project_id" {
  description = "Google Cloud project ID that will contain the dev infrastructure."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid Google Cloud project ID."
  }
}

variable "region" {
  description = "Google Cloud region for the regional GKE cluster and its subnet."
  type        = string
}

variable "environment" {
  description = "Short environment identifier used in names and labels."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,9}$", var.environment))
    error_message = "environment must be 1-10 lowercase letters, numbers, or hyphens and start with a letter."
  }
}

variable "name_prefix" {
  description = "Prefix used for Google Cloud resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,22}[a-z0-9]$", var.name_prefix))
    error_message = "name_prefix must be 3-24 lowercase letters, numbers, or hyphens and start with a letter."
  }
}

variable "network_cidr" {
  description = "Primary IPv4 range used by GKE nodes."
  type        = string

  validation {
    condition     = can(cidrhost(var.network_cidr, 0))
    error_message = "network_cidr must be a valid IPv4 CIDR."
  }
}

variable "pods_cidr" {
  description = "Secondary IPv4 range used by GKE Pods."
  type        = string

  validation {
    condition     = can(cidrhost(var.pods_cidr, 0))
    error_message = "pods_cidr must be a valid IPv4 CIDR."
  }
}

variable "services_cidr" {
  description = "Secondary IPv4 range used by Kubernetes Services."
  type        = string

  validation {
    condition     = can(cidrhost(var.services_cidr, 0))
    error_message = "services_cidr must be a valid IPv4 CIDR."
  }
}

variable "private_services_cidr" {
  description = "IPv4 range reserved for Private Services Access to Cloud SQL and other Google-managed services."
  type        = string

  validation {
    condition     = can(cidrhost(var.private_services_cidr, 0))
    error_message = "private_services_cidr must be a valid IPv4 CIDR."
  }
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
  description = "GKE release channel. REGULAR balances stability and feature availability."
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
  description = "Prevent Terraform from deleting the GKE cluster. Keep false for the disposable dev environment."
  type        = bool
}

variable "labels" {
  description = "Additional labels applied to supported Google Cloud resources."
  type        = map(string)
  default     = {}
}

variable "cloudsql_database_version" {
  description = "PostgreSQL version for the development Cloud SQL instance."
  type        = string
}

variable "cloudsql_edition" {
  description = "Cloud SQL edition for development."
  type        = string
}

variable "cloudsql_tier" {
  description = "Cloud SQL machine tier for development."
  type        = string
}

variable "cloudsql_availability_type" {
  description = "Cloud SQL availability type; ZONAL is cost-conscious for development."
  type        = string

  validation {
    condition     = contains(["ZONAL", "REGIONAL"], var.cloudsql_availability_type)
    error_message = "cloudsql_availability_type must be ZONAL or REGIONAL."
  }
}

variable "cloudsql_disk_size_gb" {
  description = "Initial SSD data disk size for Cloud SQL."
  type        = number

  validation {
    condition     = var.cloudsql_disk_size_gb >= 10
    error_message = "cloudsql_disk_size_gb must be at least 10 GB."
  }
}

variable "cloudsql_disk_autoresize_limit_gb" {
  description = "Maximum Cloud SQL disk size after automatic growth."
  type        = number

  validation {
    condition     = var.cloudsql_disk_autoresize_limit_gb == 0 || var.cloudsql_disk_autoresize_limit_gb >= var.cloudsql_disk_size_gb
    error_message = "cloudsql_disk_autoresize_limit_gb must be zero or at least cloudsql_disk_size_gb."
  }
}

variable "cloudsql_database_name" {
  description = "Initial PostgreSQL database created for the application."
  type        = string
}

variable "cloudsql_backup_start_time" {
  description = "Daily Cloud SQL backup start time in UTC."
  type        = string

  validation {
    condition     = can(regex("^(?:[01][0-9]|2[0-3]):[0-5][0-9]$", var.cloudsql_backup_start_time))
    error_message = "cloudsql_backup_start_time must use 24-hour HH:MM format."
  }
}

variable "cloudsql_retained_backups" {
  description = "Number of automated Cloud SQL backups retained."
  type        = number

  validation {
    condition     = var.cloudsql_retained_backups >= 1
    error_message = "cloudsql_retained_backups must be at least 1."
  }
}

variable "cloudsql_deletion_protection" {
  description = "Protect the Cloud SQL instance from Terraform and API deletion."
  type        = bool
}

variable "app_google_service_account_id" {
  description = "Google service account ID used by the application to connect to Cloud SQL."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.app_google_service_account_id))
    error_message = "app_google_service_account_id must be 6-30 lowercase letters, numbers, or hyphens, start with a letter, and end with a letter or number."
  }
}

variable "app_kubernetes_namespace" {
  description = "Kubernetes namespace containing the application workload."
  type        = string
}

variable "app_kubernetes_service_account" {
  description = "Kubernetes service account used by the application workload."
  type        = string
}

variable "application_domain" {
  description = "Fully qualified domain used for the application's external HTTPS endpoint."
  type        = string

  validation {
    condition     = can(regex("^(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z]{2,63}$", var.application_domain))
    error_message = "application_domain must be a lowercase fully qualified domain name, such as app.example.com."
  }
}

variable "artifact_registry_repository_id" {
  description = "Artifact Registry repository used for application container images."
  type        = string
}

variable "azure_devops_deployer_service_account_id" {
  description = "Google service account ID impersonated by Azure DevOps."
  type        = string
}

variable "azure_devops_federation_enabled" {
  description = "Enable Azure DevOps OIDC federation after the service connection identifiers have been supplied."
  type        = bool
}

variable "azure_devops_issuer_uri" {
  description = "Issuer from the Azure DevOps workload identity federation service connection."
  type        = string
  default     = null
  nullable    = true
}

variable "azure_devops_allowed_audience" {
  description = "Audience from the Azure DevOps workload identity federation service connection."
  type        = string
  default     = null
  nullable    = true
}

variable "azure_devops_subject" {
  description = "Full Subject identifier from the Azure DevOps workload identity federation service connection."
  type        = string
  default     = null
  nullable    = true
}
