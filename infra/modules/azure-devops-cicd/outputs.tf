output "deployer_service_account_email" {
  description = "Service account impersonated by the Azure DevOps pipeline."
  value       = google_service_account.azure_devops_deployer.email
}

output "artifact_registry_repository_name" {
  description = "Fully qualified Artifact Registry repository resource name."
  value       = google_artifact_registry_repository.application_images.name
}

output "artifact_registry_image_prefix" {
  description = "Registry prefix to which the pipeline appends IMAGE_NAME:IMAGE_TAG."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.application_images.repository_id}"
}

output "workload_identity_pool_name" {
  description = "Full Workload Identity pool resource name, or null while federation is disabled."
  value       = var.azure_devops_federation_enabled ? google_iam_workload_identity_pool.azure_devops[0].name : null
}

output "workload_identity_provider_name" {
  description = "Full Workload Identity provider resource name used in the pipeline credential configuration."
  value       = var.azure_devops_federation_enabled ? google_iam_workload_identity_pool_provider.azure_devops[0].name : null
}
