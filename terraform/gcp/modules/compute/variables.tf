variable "project_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "zone" {
  type = string
}

variable "machine_type" {
  type    = string
  default = "e2-small"
}

variable "boot_disk_size_gb" {
  type    = number
  default = 10
}

variable "data_disk_size_gb" {
  type    = number
  default = 10
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "service_account_email" {
  type = string
}
