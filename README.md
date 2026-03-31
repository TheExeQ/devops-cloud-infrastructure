# DevOps Cloud Infrastructure Demo ☁️

This repository contains a small Google Cloud infrastructure project built with Terraform, with space prepared for Ansible-based server configuration.

The current focus is provisioning a reusable development foundation for a portfolio-style setup that includes networking, required GCP APIs, and a PostgreSQL virtual machine.

## Overview ⚙️

The project currently defines core infrastructure such as:
- A dedicated VPC and subnet for the development environment
- Project service enablement for Compute Engine and Cloud Run
- A Debian-based PostgreSQL VM with an attached persistent disk
- SSH access restricted to a trusted external IP address

This keeps the infrastructure reproducible and gives the project a clear base for later application deployment work.

## Goals 🎯

- Practice infrastructure provisioning with Terraform on Google Cloud
- Build a simple platform that can support a containerized backend and database layer
- Leave room for Ansible-driven PostgreSQL configuration and future CI/CD expansion

## Infrastructure behavior 🔄

The development environment under `terraform/gcp/envs/dev` uses reusable Terraform modules to create networking and compute resources, while storing state in a GCS backend configured through `backend.hcl`.

When applied with environment-specific variables, the stack creates the dev VPC, subnet, firewall rule, enables required APIs, and provisions the `dev-postgres` Compute Engine instance with public SSH access limited to the configured source IP.
