output "cluster_name" {
  description = "GKE cluster name."
  value       = module.gke.cluster_name
}

output "cluster_location" {
  description = "GKE cluster region."
  value       = module.gke.cluster_location
}

output "cluster_dns_endpoint" {
  description = "DNS endpoint used to reach the GKE control plane."
  value       = module.gke.cluster_dns_endpoint
}

output "get_credentials_command" {
  description = "Command that configures kubectl to use the GKE DNS endpoint."
  value       = module.gke.get_credentials_command
}

output "network_name" {
  description = "Custom VPC network name."
  value       = module.vpc.network_name
}

output "subnetwork_name" {
  description = "GKE subnetwork name."
  value       = module.vpc.subnetwork_name
}

output "node_service_account" {
  description = "Dedicated service account used by GKE nodes."
  value       = module.gke.node_service_account_email
}

output "cloudsql_instance_name" {
  description = "Cloud SQL PostgreSQL instance name."
  value       = module.cloudsql.instance_name
}

output "cloudsql_connection_name" {
  description = "Cloud SQL connection name for the future Auth Proxy sidecar."
  value       = module.cloudsql.connection_name
}

output "cloudsql_private_ip" {
  description = "Private IPv4 address reachable from the GKE VPC."
  value       = module.cloudsql.private_ip_address
}

output "cloudsql_database_name" {
  description = "Initial PostgreSQL database name."
  value       = module.cloudsql.database_name
}

output "cloudsql_port" {
  description = "PostgreSQL listener port."
  value       = module.cloudsql.port
}

output "app_google_service_account_email" {
  description = "Google service account used by the application through Workload Identity."
  value       = module.cloudsql_workload_identity.google_service_account_email
}

output "app_kubernetes_service_account_annotation" {
  description = "Value for the iam.gke.io/gcp-service-account annotation on the application Kubernetes service account."
  value       = module.cloudsql_workload_identity.kubernetes_service_account_annotation
}

output "cloudsql_iam_database_username" {
  description = "PostgreSQL IAM username used by the application through the Cloud SQL Auth Proxy."
  value       = module.cloudsql_workload_identity.cloudsql_iam_database_username
}

output "gateway_static_ip_address" {
  description = "Global static IPv4 address to configure as the app domain's A record in GoDaddy."
  value       = module.gateway_https.gateway_static_ip_address
}

output "gateway_static_ip_name" {
  description = "Static address name used by the GKE Gateway NamedAddress configuration."
  value       = module.gateway_https.gateway_static_ip_name
}

output "gateway_certificate_map_name" {
  description = "Certificate map name used by the networking.gke.io/certmap Gateway annotation."
  value       = module.gateway_https.certificate_map_name
}

output "certificate_dns_record_type" {
  description = "GoDaddy DNS record type required for certificate authorization."
  value       = module.gateway_https.certificate_dns_record_type
}

output "certificate_dns_record_name" {
  description = "GoDaddy DNS record name required for certificate authorization."
  value       = module.gateway_https.certificate_dns_record_name
}

output "certificate_dns_record_value" {
  description = "GoDaddy DNS record target required for certificate authorization."
  value       = module.gateway_https.certificate_dns_record_value
}

output "application_url" {
  description = "Public application URL after DNS and Gateway configuration are complete."
  value       = module.gateway_https.application_url
}

output "azure_devops_deployer_service_account_email" {
  description = "Google service account impersonated by Azure DevOps."
  value       = module.azure_devops_cicd.deployer_service_account_email
}

output "artifact_registry_image_prefix" {
  description = "Registry prefix for application images."
  value       = module.azure_devops_cicd.artifact_registry_image_prefix
}

output "azure_devops_workload_identity_provider" {
  description = "Full provider name used by Azure DevOps to authenticate to Google Cloud."
  value       = module.azure_devops_cicd.workload_identity_provider_name
}
