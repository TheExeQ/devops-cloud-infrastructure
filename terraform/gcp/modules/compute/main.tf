locals {
  db_vm_name = "${var.environment}-postgres"
  postgres_ssh_user  = "admin"
  postgres_public_key  = file("~/.ssh/gcp.pub")
  postgres_private_key = pathexpand("~/.ssh/gcp")
}

resource "google_compute_disk" "postgres_data" {
  name    = "${local.db_vm_name}-data"
  type    = "pd-ssd"
  zone    = var.zone
  project = var.project_id
  size    = var.data_disk_size_gb
}

resource "google_compute_instance" "postgres" {
  name         = local.db_vm_name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id
  tags         = ["postgres"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = var.boot_disk_size_gb
      type  = "pd-standard"
    }
  }

  attached_disk {
    source      = google_compute_disk.postgres_data.id
    device_name = "postgres-data"
    mode        = "READ_WRITE"
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    network_ip = var.network_ip

    access_config {
    }
  }

metadata = {
  enable-oslogin = "FALSE"
  ssh-keys       = "${local.postgres_ssh_user}:${local.postgres_public_key}"
}

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
