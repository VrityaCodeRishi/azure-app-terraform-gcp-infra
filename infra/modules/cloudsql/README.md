# Cloud SQL module

Creates a private Cloud SQL for PostgreSQL instance and an initial application database with:

- No public IPv4 address or authorized networks
- Private Services Access through an existing VPC and allocated range
- TLS-only database connections
- SSD storage with bounded automatic growth
- Automated backups and point-in-time recovery
- Stable-track maintenance window
- Query Insights
- Configurable zonal or regional availability
- Terraform and API deletion protection controlled by one input

The module intentionally does not create database users, passwords, application service accounts, or Kubernetes resources. Application access will be added separately with Workload Identity Federation for GKE and the Cloud SQL Auth Proxy.
