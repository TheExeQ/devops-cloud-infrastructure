terraform {
  required_version = ">= 1.6.0"

  backend "gcs" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.21"
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
  zone                  = "${var.region}-b"
  network               = module.network.network_id
  subnetwork            = module.network.subnetwork_id
  service_account_email = data.google_compute_default_service_account.default.email

  depends_on = [module.network]
}
