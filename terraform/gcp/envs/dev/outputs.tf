output "cloud_run_service_name" {
  value = module.cloud_run.service_name
}

output "cloud_run_service_url" {
  value = module.cloud_run.service_url
}

output "cloud_run_service_account_email" {
  value = module.cloud_run.service_account_email
}

output "cloud_run_container_image" {
  value = local.cloud_run_container_image
}

output "cloud_run_remote_repository" {
  value = google_artifact_registry_repository.ghcr_remote.name
}
