variable "project_id" {
  description = "Google Cloud project ID in which to create the network resources."
  type        = string
}

variable "region" {
  description = "Google Cloud region for the subnet, router, and NAT gateway."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for VPC resource and secondary range names."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,35}[a-z0-9]$", var.name_prefix))
    error_message = "name_prefix must be 3-37 lowercase letters, numbers, or hyphens and start with a letter."
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
  description = "Global IPv4 range reserved for Google-managed services reached through Private Services Access."
  type        = string

  validation {
    condition     = can(cidrhost(var.private_services_cidr, 0))
    error_message = "private_services_cidr must be a valid IPv4 CIDR."
  }
}
