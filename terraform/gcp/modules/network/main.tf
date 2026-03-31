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

resource "google_compute_firewall" "allow_ssh_acces" {
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
