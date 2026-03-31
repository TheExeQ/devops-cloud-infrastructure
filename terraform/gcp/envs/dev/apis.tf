locals {
  gcp_apis = ["compute.googleapis.com", "run.googleapis.com"]
}

resource "google_project_service" "compute" {
  project = var.project_id

  for_each = toset(local.gcp_apis)
  service  = each.value

  disable_on_destroy = false
}
