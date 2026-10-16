module "vpc" {
  source = "../../modules/vpc"

  project_id            = var.project_id
  region                = var.region
  name_prefix           = local.resource_prefix
  network_cidr          = var.network_cidr
  pods_cidr             = var.pods_cidr
  services_cidr         = var.services_cidr
  private_services_cidr = var.private_services_cidr

  depends_on = [
    google_project_service.required["compute.googleapis.com"],
    google_project_service.required["servicenetworking.googleapis.com"],
  ]
}

module "gke" {
  source = "../../modules/gke"

  project_id  = var.project_id
  region      = var.region
  name_prefix = local.resource_prefix
  labels      = local.common_labels

  network_id                    = module.vpc.network_id
  subnetwork_id                 = module.vpc.subnetwork_id
  pods_secondary_range_name     = module.vpc.pods_secondary_range_name
  services_secondary_range_name = module.vpc.services_secondary_range_name

  node_machine_type         = var.node_machine_type
  node_disk_size_gb         = var.node_disk_size_gb
  node_pool_total_min_nodes = var.node_pool_total_min_nodes
  node_pool_total_max_nodes = var.node_pool_total_max_nodes
  release_channel           = var.release_channel
  maintenance_start_time    = var.maintenance_start_time
  deletion_protection       = var.deletion_protection

  depends_on = [
    google_project_service.required["compute.googleapis.com"],
    google_project_service.required["container.googleapis.com"],
    google_project_service.required["iam.googleapis.com"],
    google_project_service.required["logging.googleapis.com"],
    google_project_service.required["monitoring.googleapis.com"],
  ]
}

module "cloudsql" {
  source = "../../modules/cloudsql"

  project_id  = var.project_id
  region      = var.region
  name_prefix = local.resource_prefix
  labels      = local.common_labels

  network_id                  = module.vpc.network_id
  private_services_range_name = module.vpc.private_services_range_name

  database_version         = var.cloudsql_database_version
  edition                  = var.cloudsql_edition
  tier                     = var.cloudsql_tier
  availability_type        = var.cloudsql_availability_type
  disk_size_gb             = var.cloudsql_disk_size_gb
  disk_autoresize_limit_gb = var.cloudsql_disk_autoresize_limit_gb
  database_name            = var.cloudsql_database_name
  backup_start_time        = var.cloudsql_backup_start_time
  retained_backups         = var.cloudsql_retained_backups
  deletion_protection      = var.cloudsql_deletion_protection

  depends_on = [
    google_project_service.required["sqladmin.googleapis.com"],
    google_project_service.required["servicenetworking.googleapis.com"],
    module.vpc,
  ]
}

module "cloudsql_workload_identity" {
  source = "../../modules/cloudsql-workload-identity"

  project_id                          = var.project_id
  google_service_account_id           = var.app_google_service_account_id
  google_service_account_display_name = "${local.resource_prefix} application Cloud SQL identity"
  workload_identity_pool              = module.gke.workload_identity_pool
  kubernetes_namespace                = var.app_kubernetes_namespace
  kubernetes_service_account          = var.app_kubernetes_service_account
  cloudsql_instance_name              = module.cloudsql.instance_name

  depends_on = [
    google_project_service.required["iam.googleapis.com"],
    google_project_service.required["sqladmin.googleapis.com"],
  ]
}

module "gateway_https" {
  source = "../../modules/gateway-https"

  project_id  = var.project_id
  name_prefix = local.resource_prefix
  domain      = var.application_domain
  labels      = local.common_labels

  depends_on = [
    google_project_service.required["certificatemanager.googleapis.com"],
    google_project_service.required["compute.googleapis.com"],
  ]
}

module "azure_devops_cicd" {
  source = "../../modules/azure-devops-cicd"

  project_id                            = var.project_id
  project_number                        = data.google_project.target_project.number
  region                                = var.region
  artifact_registry_repository_id       = var.artifact_registry_repository_id
  gke_node_service_account_email        = module.gke.node_service_account_email
  deployer_service_account_id           = var.azure_devops_deployer_service_account_id
  deployer_service_account_display_name = "${local.resource_prefix} Azure DevOps deployer"
  azure_devops_federation_enabled       = var.azure_devops_federation_enabled
  azure_devops_issuer_uri               = var.azure_devops_issuer_uri
  azure_devops_allowed_audience         = var.azure_devops_allowed_audience
  azure_devops_subject                  = var.azure_devops_subject
  labels                                = local.common_labels

  depends_on = [
    google_project_service.required["artifactregistry.googleapis.com"],
    google_project_service.required["iam.googleapis.com"],
    google_project_service.required["iamcredentials.googleapis.com"],
    google_project_service.required["sts.googleapis.com"],
  ]
}
