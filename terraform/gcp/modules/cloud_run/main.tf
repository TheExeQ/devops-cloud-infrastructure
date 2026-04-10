resource "google_service_account" "cloud_run" {
  account_id   = substr("${var.environment}-${var.service_name}-run", 0, 30)
  display_name = "${var.environment} ${var.service_name} Cloud Run"
  project      = var.project_id
}

resource "google_cloud_run_v2_service" "service" {
  name     = "${var.environment}-${var.service_name}"
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"

  deletion_protection = false

  template {
    service_account = google_service_account.cloud_run.email

vpc_access {
    connector = var.vpc_connector
    egress    = var.vpc_egress
  }

    scaling {
      min_instance_count = var.min_instance_count
      max_instance_count = var.max_instance_count
    }

    containers {
      image = var.container_image

      env {
        name = "DATABASE_URL"
        value = var.database_url
      }

      ports {
        container_port = var.container_port
      }

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "public" {
  count    = var.allow_unauthenticated ? 1 : 0
  project  = var.project_id
  location = google_cloud_run_v2_service.service.location
  name     = google_cloud_run_v2_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
