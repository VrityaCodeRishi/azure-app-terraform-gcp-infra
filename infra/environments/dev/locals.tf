locals {
  resource_prefix = "${var.name_prefix}-${var.environment}"

  common_labels = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
      project     = var.name_prefix
    },
    var.labels
  )

  required_apis = toset([
    "artifactregistry.googleapis.com",
    "certificatemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "sts.googleapis.com",
  ])
}
