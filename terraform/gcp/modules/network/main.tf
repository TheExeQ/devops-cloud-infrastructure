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

resource "google_compute_firewall" "allow_iap_ssh_access" {
  name    = "allow-iap-ssh-access"
  network = google_compute_network.vpc.id

  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["postgres"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_router" "nat" {
  name    = "${var.environment}-nat-router"
  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "subnet" {
  name                               = "${var.environment}-nat"
  project                            = var.project_id
  region                             = var.region
  router                             = google_compute_router.nat.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
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
