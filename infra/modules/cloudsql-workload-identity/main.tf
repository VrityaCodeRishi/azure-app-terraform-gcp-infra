resource "google_service_account" "application_cloudsql" {
  project      = var.project_id
  account_id   = var.google_service_account_id
  display_name = var.google_service_account_display_name
  description  = "Workload Identity service account used by ${var.kubernetes_namespace}/${var.kubernetes_service_account} to connect to Cloud SQL."
}

resource "google_project_iam_member" "cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.application_cloudsql.email}"
}

resource "google_project_iam_member" "cloudsql_instance_user" {
  project = var.project_id
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${google_service_account.application_cloudsql.email}"
}

resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.application_cloudsql.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.workload_identity_pool}[${var.kubernetes_namespace}/${var.kubernetes_service_account}]"
}

resource "google_sql_user" "application_iam_user" {
  project  = var.project_id
  instance = var.cloudsql_instance_name
  name     = trimsuffix(google_service_account.application_cloudsql.email, ".gserviceaccount.com")
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
}
