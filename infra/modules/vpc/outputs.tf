output "network_id" {
  description = "Fully qualified ID of the custom VPC network."
  value       = google_compute_network.gke_vpc.id
}

output "network_name" {
  description = "Name of the custom VPC network."
  value       = google_compute_network.gke_vpc.name
}

output "subnetwork_id" {
  description = "Fully qualified ID of the GKE subnetwork."
  value       = google_compute_subnetwork.gke_subnet.id
}

output "subnetwork_name" {
  description = "Name of the GKE subnetwork."
  value       = google_compute_subnetwork.gke_subnet.name
}

output "pods_secondary_range_name" {
  description = "Name of the secondary IP range allocated to GKE Pods."
  value       = google_compute_subnetwork.gke_subnet.secondary_ip_range[0].range_name
}

output "services_secondary_range_name" {
  description = "Name of the secondary IP range allocated to Kubernetes Services."
  value       = google_compute_subnetwork.gke_subnet.secondary_ip_range[1].range_name
}

output "nat_name" {
  description = "Name of the Cloud NAT configuration."
  value       = google_compute_router_nat.gke_nat.name
}

output "private_services_range_name" {
  description = "Name of the global address range reserved for Private Services Access."
  value       = google_compute_global_address.private_services_range.name
}

output "private_services_connection" {
  description = "Private Services Access connection used by Google-managed services such as Cloud SQL."
  value       = google_service_networking_connection.private_services_connection.id
}
