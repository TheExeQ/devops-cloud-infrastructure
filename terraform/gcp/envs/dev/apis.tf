locals {
  gcp_apis = ["artifactregistry.googleapis.com", "compute.googleapis.com", "iam.googleapis.com", "iap.googleapis.com", "oslogin.googleapis.com", "run.googleapis.com", "vpcaccess.googleapis.com", "cloudresourcemanager.googleapis.com", "serviceusage.googleapis.com"]
}

resource "google_project_service" "compute" {
  project = var.project_id

  for_each = toset(local.gcp_apis)
  service  = each.value

  disable_on_destroy = false
}
