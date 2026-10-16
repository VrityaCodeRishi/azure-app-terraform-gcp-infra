locals {
  node_service_account_id = trimsuffix(substr("${var.name_prefix}-gke-nodes", 0, 30), "-")
}

resource "google_service_account" "nodes" {
  project      = var.project_id
  account_id   = local.node_service_account_id
  display_name = "${var.name_prefix} GKE node service account"
}

resource "google_project_iam_member" "node_service_account" {
  project = var.project_id
  role    = "roles/container.defaultNodeServiceAccount"
  member  = "serviceAccount:${google_service_account.nodes.email}"
}

resource "google_container_cluster" "gke_cluster" {
  name     = "${var.name_prefix}-gke"
  project  = var.project_id
  location = var.region

  network    = var.network_id
  subnetwork = var.subnetwork_id

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }


  private_cluster_config {
    enable_private_nodes = true
  }


  control_plane_endpoints_config {
    dns_endpoint_config {
      allow_external_traffic = true
    }

    ip_endpoints_config {
      enabled = false
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }

  release_channel {
    channel = var.release_channel
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_start_time
    }
  }

  datapath_provider        = "ADVANCED_DATAPATH"
  enable_shielded_nodes    = true
  deletion_protection      = var.deletion_protection
  remove_default_node_pool = true
  initial_node_count       = 1

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  monitoring_config {
    enable_components = [
      "SYSTEM_COMPONENTS",
      "APISERVER",
      "SCHEDULER",
      "CONTROLLER_MANAGER",
      "STORAGE",
      "POD",
      "DEPLOYMENT",
      "STATEFULSET",
      "DAEMONSET",
      "HPA",
    ]

    managed_prometheus {
      enabled = true
    }
  }

  resource_labels = var.labels

  depends_on = [google_project_iam_member.node_service_account]
}

resource "google_container_node_pool" "primary" {
  name     = "primary"
  project  = var.project_id
  location = var.region
  cluster  = google_container_cluster.gke_cluster.name

  initial_node_count = var.node_pool_total_min_nodes

  autoscaling {
    total_min_node_count = var.node_pool_total_min_nodes
    total_max_node_count = var.node_pool_total_max_nodes
    location_policy      = "BALANCED"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
    strategy        = "SURGE"
  }

  node_config {
    machine_type    = var.node_machine_type
    image_type      = "COS_CONTAINERD"
    disk_type       = "pd-balanced"
    disk_size_gb    = var.node_disk_size_gb
    service_account = google_service_account.nodes.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    labels = merge(var.labels, {
      node_pool = "primary"
    })

    metadata = {
      disable-legacy-endpoints = "true"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}
