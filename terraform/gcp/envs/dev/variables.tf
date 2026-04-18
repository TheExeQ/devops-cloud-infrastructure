variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "environment" {
  type = string
}

variable "subnet_cidr" {
  type    = string
  default = "10.10.0.0/24"
}

variable "postgres_instance_ip" {
  type    = string
  default = "10.10.0.10"
}

variable "vpc_connector_cidr" {
  type    = string
  default = "10.8.0.0/28"
}

variable "cloud_run_service_name" {
  type    = string
  default = "app"
}

variable "cloud_run_remote_repository_id" {
  type    = string
  default = "ghcr-remote"
}

variable "cloud_run_upstream_image_path" {
  type    = string
  default = "theexeq/app:latest"
}

variable "cloud_run_container_port" {
  type    = number
  default = 3000
}

variable "cloud_run_allow_unauthenticated" {
  type    = bool
  default = true
}

variable "cloud_run_min_instance_count" {
  type    = number
  default = 0
}

variable "cloud_run_max_instance_count" {
  type    = number
  default = 1
}

variable "cloud_run_cpu" {
  type    = string
  default = "1"
}

variable "cloud_run_memory" {
  type    = string
  default = "512Mi"
}
