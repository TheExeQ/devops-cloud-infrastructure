terraform {
  required_version = ">= 1.6.0"

  backend "gcs" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.21"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_compute_default_service_account" "default" {
  project = var.project_id
}

module "network" {
  source = "../../modules/network"

  project_id         = var.project_id
  region             = var.region
  environment        = var.environment
  subnet_cidr        = var.subnet_cidr
  external_access_ip = var.external_access_ip

  depends_on = [google_project_service.compute]
}

module "compute" {
  source = "../../modules/compute"

  project_id            = var.project_id
  environment           = var.environment
  zone                  = "${var.region}-${var.zone}"
  network               = module.network.network_id
  subnetwork            = module.network.subnetwork_id
  service_account_email = data.google_compute_default_service_account.default.email

  depends_on = [module.network]
}

resource "local_file" "ansible_postgres_inventory" {
  filename        = "${path.root}/../../../../ansible/inventories/dev/postgres.inventory.ini"
  content         = <<-EOT
    [postgres]
    ${module.compute.postgres_name} ansible_host=${module.compute.postgres_public_ip} ansible_user=${module.compute.postgres_ssh_user} ansible_ssh_private_key_file=${module.compute.postgres_ssh_private_key}
  EOT
  file_permission = "0644"
}

module "cloud_run" {
  source = "../../modules/cloud_run"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  service_name          = var.cloud_run_service_name
  container_image       = local.cloud_run_container_image
  container_port        = var.cloud_run_container_port
  allow_unauthenticated = var.cloud_run_allow_unauthenticated
  min_instance_count    = var.cloud_run_min_instance_count
  max_instance_count    = var.cloud_run_max_instance_count
  cpu                   = var.cloud_run_cpu
  memory                = var.cloud_run_memory

  depends_on = [google_project_service.compute, google_artifact_registry_repository.ghcr_remote]
}
