variable "project_id" {
  description = "Google Cloud project containing the Gateway HTTPS resources."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for Gateway HTTPS resource names."
  type        = string
}

variable "domain" {
  description = "Fully qualified application domain covered by the managed certificate."
  type        = string

  validation {
    condition     = can(regex("^(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z]{2,63}$", var.domain))
    error_message = "domain must be a lowercase fully qualified domain name, such as app.example.com."
  }
}

variable "labels" {
  description = "Labels applied to supported Gateway HTTPS resources."
  type        = map(string)
  default     = {}
}
