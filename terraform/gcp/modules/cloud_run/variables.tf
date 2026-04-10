variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "service_name" {
  type    = string
}

variable "vpc_connector" {
  type = string
}

variable "vpc_egress" {
  type    = string
  default = "PRIVATE_RANGES_ONLY"
}

variable "container_image" {
  type = string
}

variable "database_url" {
  type = string
}

variable "container_port" {
  type    = number
}

variable "allow_unauthenticated" {
  type    = bool
}

variable "min_instance_count" {
  type    = number
}

variable "max_instance_count" {
  type    = number
}

variable "cpu" {
  type    = string
}

variable "memory" {
  type    = string
}
