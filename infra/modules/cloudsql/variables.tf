variable "project_id" {
  description = "Google Cloud project ID in which to create the Cloud SQL resources."
  type        = string
}

variable "region" {
  description = "Google Cloud region for the Cloud SQL instance."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for Cloud SQL resource names."
  type        = string
}

variable "network_id" {
  description = "Fully qualified ID of the VPC used for the instance private IP."
  type        = string
}

variable "private_services_range_name" {
  description = "Name of the allocated Private Services Access range used by Cloud SQL."
  type        = string
}

variable "database_version" {
  description = "Cloud SQL PostgreSQL database version."
  type        = string
  default     = "POSTGRES_16"

  validation {
    condition     = can(regex("^POSTGRES_[0-9]+$", var.database_version))
    error_message = "database_version must be a PostgreSQL version such as POSTGRES_16."
  }
}

variable "edition" {
  description = "Cloud SQL edition."
  type        = string
  default     = "ENTERPRISE"

  validation {
    condition     = contains(["ENTERPRISE", "ENTERPRISE_PLUS"], var.edition)
    error_message = "edition must be ENTERPRISE or ENTERPRISE_PLUS."
  }
}

variable "tier" {
  description = "Cloud SQL machine tier."
  type        = string
  default     = "db-custom-1-3840"
}

variable "availability_type" {
  description = "ZONAL for development or REGIONAL for high availability."
  type        = string
  default     = "ZONAL"

  validation {
    condition     = contains(["ZONAL", "REGIONAL"], var.availability_type)
    error_message = "availability_type must be ZONAL or REGIONAL."
  }
}

variable "disk_size_gb" {
  description = "Initial SSD data disk size in GB."
  type        = number
  default     = 20

  validation {
    condition     = var.disk_size_gb >= 10
    error_message = "disk_size_gb must be at least 10 GB."
  }
}

variable "disk_autoresize_limit_gb" {
  description = "Maximum size in GB to which Cloud SQL can automatically grow the data disk."
  type        = number
  default     = 100

  validation {
    condition     = var.disk_autoresize_limit_gb == 0 || var.disk_autoresize_limit_gb >= var.disk_size_gb
    error_message = "disk_autoresize_limit_gb must be zero for no explicit limit or at least disk_size_gb."
  }
}

variable "database_name" {
  description = "Initial PostgreSQL database created inside the instance."
  type        = string
  default     = "app"

  validation {
    condition     = can(regex("^[a-z][a-z0-9_]{0,62}$", var.database_name))
    error_message = "database_name must start with a lowercase letter and contain only lowercase letters, numbers, or underscores."
  }
}

variable "backup_start_time" {
  description = "Daily automated-backup start time in UTC using HH:MM format."
  type        = string
  default     = "19:00"

  validation {
    condition     = can(regex("^(?:[01][0-9]|2[0-3]):[0-5][0-9]$", var.backup_start_time))
    error_message = "backup_start_time must use 24-hour HH:MM format."
  }
}

variable "retained_backups" {
  description = "Number of automated backups retained."
  type        = number
  default     = 7

  validation {
    condition     = var.retained_backups >= 1
    error_message = "retained_backups must be at least 1."
  }
}

variable "transaction_log_retention_days" {
  description = "Number of PostgreSQL transaction-log days retained for point-in-time recovery."
  type        = number
  default     = 7

  validation {
    condition     = var.transaction_log_retention_days >= 1 && var.transaction_log_retention_days <= 7
    error_message = "transaction_log_retention_days must be between 1 and 7 for the Enterprise edition."
  }
}

variable "maintenance_day" {
  description = "Cloud SQL maintenance day, where 1 is Monday and 7 is Sunday."
  type        = number
  default     = 7

  validation {
    condition     = var.maintenance_day >= 1 && var.maintenance_day <= 7
    error_message = "maintenance_day must be between 1 and 7."
  }
}

variable "maintenance_hour" {
  description = "Cloud SQL maintenance-window start hour in UTC."
  type        = number
  default     = 21

  validation {
    condition     = var.maintenance_hour >= 0 && var.maintenance_hour <= 23
    error_message = "maintenance_hour must be between 0 and 23."
  }
}

variable "connector_enforcement" {
  description = "Whether all database connections must use the Cloud SQL Auth Proxy or a language connector."
  type        = string
  default     = "NOT_REQUIRED"

  validation {
    condition     = contains(["REQUIRED", "NOT_REQUIRED"], var.connector_enforcement)
    error_message = "connector_enforcement must be REQUIRED or NOT_REQUIRED."
  }
}

variable "deletion_protection" {
  description = "Protect the Cloud SQL instance from deletion in both Terraform and the Cloud SQL API."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels applied to the Cloud SQL instance."
  type        = map(string)
  default     = {}
}
