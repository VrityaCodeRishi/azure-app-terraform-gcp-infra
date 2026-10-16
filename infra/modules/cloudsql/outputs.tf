output "instance_name" {
  description = "Cloud SQL instance name."
  value       = google_sql_database_instance.postgres_instance.name
}

output "connection_name" {
  description = "Cloud SQL connection name used by the Auth Proxy and language connectors."
  value       = google_sql_database_instance.postgres_instance.connection_name
}

output "private_ip_address" {
  description = "Private IPv4 address assigned to the Cloud SQL instance."
  value       = google_sql_database_instance.postgres_instance.private_ip_address
}

output "database_name" {
  description = "Initial PostgreSQL database name."
  value       = google_sql_database.application_database.name
}

output "port" {
  description = "PostgreSQL listener port."
  value       = 5432
}
