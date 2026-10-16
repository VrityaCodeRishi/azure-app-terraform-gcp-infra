resource "google_project_service" "required" {
  for_each = local.required_apis

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

data "google_project" "target_project" {
  project_id = var.project_id
}
