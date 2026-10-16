output "google_service_account_email" {
  description = "Email address of the application Google service account."
  value       = google_service_account.application_cloudsql.email
}

output "kubernetes_service_account_annotation" {
  description = "Annotation value that links the Kubernetes service account to the Google service account."
  value       = google_service_account.application_cloudsql.email
}

output "cloudsql_iam_database_username" {
  description = "PostgreSQL username used for automatic IAM database authentication."
  value       = google_sql_user.application_iam_user.name
}
