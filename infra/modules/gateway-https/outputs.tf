output "gateway_static_ip_address" {
  description = "Global static IPv4 address to configure as the application domain's A record and on the GKE Gateway."
  value       = google_compute_global_address.gateway_public_ip.address
}

output "gateway_static_ip_name" {
  description = "Name used in the GKE Gateway NamedAddress configuration."
  value       = google_compute_global_address.gateway_public_ip.name
}

output "certificate_map_name" {
  description = "Certificate map name used by the networking.gke.io/certmap Gateway annotation."
  value       = google_certificate_manager_certificate_map.gateway_certificate_map.name
}

output "certificate_dns_record_type" {
  description = "Type of DNS record that must be created in GoDaddy for certificate authorization."
  value       = google_certificate_manager_dns_authorization.application_domain.dns_resource_record[0].type
}

output "certificate_dns_record_name" {
  description = "Name of the DNS record that must be created in GoDaddy for certificate authorization."
  value       = google_certificate_manager_dns_authorization.application_domain.dns_resource_record[0].name
}

output "certificate_dns_record_value" {
  description = "Target of the DNS record that must be created in GoDaddy for certificate authorization."
  value       = google_certificate_manager_dns_authorization.application_domain.dns_resource_record[0].data
}

output "application_url" {
  description = "Public HTTPS URL for the application after DNS and Gateway configuration are complete."
  value       = "https://${var.domain}"
}
