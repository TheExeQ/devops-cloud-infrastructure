output "postgres_name" {
  value = google_compute_instance.postgres.name
}
output "postgres_public_ip" {
  value = google_compute_instance.postgres.network_interface[0].access_config[0].nat_ip
}
output "postgres_ssh_user" {
  value = local.postgres_ssh_user
}
output "postgres_ssh_private_key" {
  value = local.postgres_private_key
}
