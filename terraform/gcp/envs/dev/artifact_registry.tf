locals {
  cloud_run_container_image = format(
    "%s-docker.pkg.dev/%s/%s/%s",
    var.region,
    var.project_id,
    google_artifact_registry_repository.ghcr_remote.repository_id,
    var.cloud_run_upstream_image_path,
  )
}

resource "google_artifact_registry_repository" "ghcr_remote" {
  project       = var.project_id
  location      = var.region
  repository_id = var.cloud_run_remote_repository_id
  description   = "Remote Docker repository proxying GHCR for Cloud Run"
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"

  remote_repository_config {
    description = "GHCR pull-through cache"

    common_repository {
      uri = "https://ghcr.io"
    }
  }
}
