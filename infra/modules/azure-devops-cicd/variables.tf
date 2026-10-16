variable "project_id" {
  description = "Google Cloud project containing Artifact Registry and GKE."
  type        = string
}

variable "project_number" {
  description = "Numeric Google Cloud project number used in Workload Identity principal identifiers."
  type        = string

  validation {
    condition     = can(regex("^[0-9]+$", var.project_number))
    error_message = "project_number must contain only digits."
  }
}

variable "region" {
  description = "Artifact Registry repository location."
  type        = string
}

variable "artifact_registry_repository_id" {
  description = "Repository ID for application container images."
  type        = string
  default     = "application"
}

variable "gke_node_service_account_email" {
  description = "Email address of the GKE node service account that pulls application images from Artifact Registry."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]@[a-z][a-z0-9-]{4,28}[a-z0-9]\\.iam\\.gserviceaccount\\.com$", var.gke_node_service_account_email))
    error_message = "gke_node_service_account_email must be a valid Google service account email address."
  }
}

variable "deployer_service_account_id" {
  description = "Account ID for the Azure DevOps deployment service account."
  type        = string
  default     = "azure-devops-deployer"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.deployer_service_account_id))
    error_message = "deployer_service_account_id must be 6-30 lowercase letters, numbers, or hyphens, start with a letter, and end with a letter or number."
  }
}

variable "deployer_service_account_display_name" {
  description = "Human-readable name for the Azure DevOps deployer service account."
  type        = string
  default     = "Azure DevOps GKE deployer"
}

variable "azure_devops_federation_enabled" {
  description = "Create the Azure DevOps OIDC Workload Identity pool, provider, and impersonation binding."
  type        = bool
  default     = false
}

variable "workload_identity_pool_id" {
  description = "ID of the Workload Identity pool dedicated to Azure DevOps."
  type        = string
  default     = "azure-devops"
}

variable "workload_identity_provider_id" {
  description = "ID of the Azure DevOps OIDC provider in the Workload Identity pool."
  type        = string
  default     = "azure-devops-oidc"
}

variable "azure_devops_issuer_uri" {
  description = "Issuer shown in the Azure DevOps workload identity federation service connection."
  type        = string
  default     = null
  nullable    = true
}

variable "azure_devops_allowed_audience" {
  description = "Audience shown in the Azure DevOps workload identity federation service connection."
  type        = string
  default     = null
  nullable    = true
}

variable "azure_devops_subject" {
  description = "Full Subject identifier shown in the Azure DevOps workload identity federation service connection. The provider validates it exactly and maps the portion following /sc/ to google.subject."
  type        = string
  default     = null
  nullable    = true
}

variable "labels" {
  description = "Labels applied to the Artifact Registry repository."
  type        = map(string)
  default     = {}
}
