output "cluster_name" {
  description = "GKE cluster name."
  value       = google_container_cluster.gke_cluster.name
}

output "cluster_location" {
  description = "GKE cluster region."
  value       = google_container_cluster.gke_cluster.location
}

output "cluster_dns_endpoint" {
  description = "DNS endpoint used to reach the GKE control plane."
  value       = google_container_cluster.gke_cluster.control_plane_endpoints_config[0].dns_endpoint_config[0].endpoint
}

output "get_credentials_command" {
  description = "Command that configures kubectl to use the GKE DNS endpoint."
  value       = "gcloud container clusters get-credentials ${google_container_cluster.gke_cluster.name} --region ${var.region} --project ${var.project_id} --dns-endpoint"
}

output "node_service_account_email" {
  description = "Email address of the dedicated GKE node service account."
  value       = google_service_account.nodes.email
}

output "workload_identity_pool" {
  description = "Workload Identity pool used to authorize Kubernetes service accounts."
  value       = google_container_cluster.gke_cluster.workload_identity_config[0].workload_pool
}
