resource "google_compute_network" "vpc" {
  name                    = "${var.environment}-vpc"
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.environment}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

resource "google_compute_firewall" "allow_ssh_access" {
  name    = "allow-ssh-access"
  network = google_compute_network.vpc.id

  direction     = "INGRESS"
  source_ranges = ["${var.external_access_ip}/32"]
  target_tags   = ["postgres"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_vpc_access_connector" "connector" {
  name          = "vpc-${var.environment}-run-connector"
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.vpc_connector_cidr

  min_instances = 2
  max_instances = 3
}
