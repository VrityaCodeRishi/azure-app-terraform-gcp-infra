resource "google_compute_global_address" "gateway_public_ip" {
  project      = var.project_id
  name         = "${var.name_prefix}-gateway-ip"
  description  = "Stable public IPv4 address used by the external GKE Gateway."
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
  labels       = var.labels
}

resource "google_certificate_manager_dns_authorization" "application_domain" {
  project     = var.project_id
  name        = "${var.name_prefix}-dns-auth"
  description = "DNS authorization for the application HTTPS certificate."
  domain      = var.domain
  type        = "PER_PROJECT_RECORD"
  labels      = var.labels
}

resource "google_certificate_manager_certificate" "application_certificate" {
  project     = var.project_id
  name        = "${var.name_prefix}-certificate"
  description = "Google-managed TLS certificate for ${var.domain}."
  scope       = "DEFAULT"
  labels      = var.labels

  managed {
    domains            = [var.domain]
    dns_authorizations = [google_certificate_manager_dns_authorization.application_domain.id]
  }
}

resource "google_certificate_manager_certificate_map" "gateway_certificate_map" {
  project     = var.project_id
  name        = "${var.name_prefix}-certificate-map"
  description = "Certificate map attached to the external GKE Gateway."
  labels      = var.labels
}

resource "google_certificate_manager_certificate_map_entry" "application_domain" {
  project      = var.project_id
  name         = "${var.name_prefix}-domain"
  description  = "TLS certificate selection for ${var.domain}."
  map          = google_certificate_manager_certificate_map.gateway_certificate_map.name
  hostname     = var.domain
  certificates = [google_certificate_manager_certificate.application_certificate.id]
  labels       = var.labels
}
