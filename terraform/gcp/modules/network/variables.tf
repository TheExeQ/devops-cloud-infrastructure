variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR range for the subnet"
}

variable "vpc_connector_cidr" {
  type = string
  description = "CIDR range for the vpc connector"
}

variable "external_access_ip" {
  type = string
  description = "Allowed ssh for external ip"
}
