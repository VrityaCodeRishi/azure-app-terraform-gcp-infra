locals {
  azure_devops_issuer_uri       = coalesce(var.azure_devops_issuer_uri, "https://invalid.example")
  azure_devops_allowed_audience = coalesce(var.azure_devops_allowed_audience, "not-configured")
  azure_devops_subject          = coalesce(var.azure_devops_subject, "not-configured")
  azure_devops_mapped_subject   = try(split("/sc/", local.azure_devops_subject)[1], "not-configured")
}

resource "google_artifact_registry_repository" "application_images" {
  project       = var.project_id
  location      = var.region
  repository_id = var.artifact_registry_repository_id
  description   = "Docker images built by Azure DevOps for the application."
  format        = "DOCKER"
  labels        = var.labels
}

resource "google_service_account" "azure_devops_deployer" {
  project      = var.project_id
  account_id   = var.deployer_service_account_id
  display_name = var.deployer_service_account_display_name
  description  = "Keyless Azure DevOps identity used to push images and deploy workloads to GKE."
}

resource "google_artifact_registry_repository_iam_member" "repository_writer" {
  project    = var.project_id
  location   = google_artifact_registry_repository.application_images.location
  repository = google_artifact_registry_repository.application_images.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.azure_devops_deployer.email}"
}

resource "google_artifact_registry_repository_iam_member" "gke_nodes_reader" {
  project    = var.project_id
  location   = google_artifact_registry_repository.application_images.location
  repository = google_artifact_registry_repository.application_images.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${var.gke_node_service_account_email}"
}

resource "google_project_iam_member" "gke_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.azure_devops_deployer.email}"
}

resource "google_iam_workload_identity_pool" "azure_devops" {
  count = var.azure_devops_federation_enabled ? 1 : 0

  project                   = var.project_id
  workload_identity_pool_id = var.workload_identity_pool_id
  display_name              = "Azure DevOps pipelines"
  description               = "Trust boundary for Azure DevOps deployment pipelines."
}

resource "google_iam_workload_identity_pool_provider" "azure_devops" {
  count = var.azure_devops_federation_enabled ? 1 : 0

  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.azure_devops[0].workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_provider_id
  display_name                       = "Azure DevOps OIDC"
  description                        = "Accepts OIDC tokens from the approved Azure DevOps service connection."

  attribute_mapping = {
    "google.subject" = "assertion.sub.split('/sc/')[1]"
  }

  attribute_condition = "assertion.sub == '${local.azure_devops_subject}'"

  oidc {
    issuer_uri        = local.azure_devops_issuer_uri
    allowed_audiences = [local.azure_devops_allowed_audience]
  }
}

resource "google_service_account_iam_member" "azure_devops_workload_identity_user" {
  count = var.azure_devops_federation_enabled ? 1 : 0

  service_account_id = google_service_account.azure_devops_deployer.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.azure_devops[0].workload_identity_pool_id}/subject/${local.azure_devops_mapped_subject}"
}

check "azure_devops_federation_configuration" {
  assert {
    condition = !var.azure_devops_federation_enabled || alltrue([
      var.azure_devops_issuer_uri != null,
      var.azure_devops_allowed_audience != null,
      var.azure_devops_subject != null,
      try(length(split("/sc/", var.azure_devops_subject)) == 2, false),
      try(length(split("/sc/", var.azure_devops_subject)[1]) <= 127, false),
    ])
    error_message = "When Azure DevOps federation is enabled, issuer URI, allowed audience, and the full Azure DevOps subject must be supplied. The subject must contain one /sc/ delimiter and its mapped suffix must not exceed 127 characters."
  }
}
