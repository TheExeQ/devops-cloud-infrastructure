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
