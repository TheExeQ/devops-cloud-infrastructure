# DevOps Cloud Infrastructure Demo

[![CICD](https://github.com/TheExeQ/devops-cloud-infrastructure/actions/workflows/setup-infra.yml/badge.svg)](https://github.com/TheExeQ/devops-cloud-infrastructure/actions/workflows/setup-infra.yml)

This repository contains a Google Cloud infrastructure project built around Terraform-style infrastructure as code, with Ansible used for post-provisioning server configuration.

The project now covers more than a base network and database VM. It also includes container deployment support, private service-to-database connectivity, image registry integration, and CI-driven provisioning workflows.

## Overview

The stack currently provisions and manages:
- A dedicated VPC and subnet for an isolated development environment
- Required Google Cloud API enablement for compute, networking, identity, and serverless services
- A PostgreSQL virtual machine running on Debian with a separate persistent data disk
- OS Login based SSH access routed through Identity-Aware Proxy instead of direct public VM access
- Cloud NAT for outbound internet access from private resources
- A Serverless VPC Access connector so Cloud Run services can reach private network resources
- A Cloud Run service with configurable scaling, CPU, memory, port, and public access behavior
- An Artifact Registry remote Docker repository used as a pull-through cache for upstream images

## Goals

- Practice infrastructure provisioning on Google Cloud with reusable modules
- Build a small but realistic platform that supports both a database layer and a containerized application layer
- Keep infrastructure reproducible while separating provisioning from operating-system and database configuration
- Leave room for future CI/CD, security hardening, and environment expansion

## Infrastructure Behavior

The infrastructure is organized around reusable modules and environment-specific variables. State is stored remotely, and the environment can be parameterized for project, region, sizing, networking, and application runtime settings.

At a high level, applying the stack will:
- Enable the cloud services required by the platform
- Create the network, subnet, firewall rules, NAT, and serverless connector
- Provision a private PostgreSQL VM with OS Login enabled and project SSH keys blocked
- Create a Cloud Run service wired to the private network through the VPC connector
- Build the Cloud Run image reference from a remote Artifact Registry repository and an upstream container image path
- Expose outputs for the deployed application service and related runtime identity details

## Configuration Management

Ansible is used after infrastructure provisioning to configure the PostgreSQL host. The current automation installs PostgreSQL, updates core server settings, applies host-based authentication rules, ensures the service is running, and creates an initial database.

The inventory is dynamic and uses Google Cloud metadata rather than a manually maintained host list. SSH access is tunneled through IAP, which keeps the VM reachable for administration without depending on a public IP.

## Automation

The repository includes GitHub Actions workflows for both environment creation and teardown.

The setup workflow currently:
- Authenticates to Google Cloud
- Runs formatting and validation checks for the infrastructure code
- Applies the infrastructure
- Installs Ansible dependencies
- Creates a short-lived OS Login SSH key
- Runs the PostgreSQL configuration playbook
- Removes the temporary SSH key after the run

The destroy workflow performs authenticated teardown after an explicit confirmation step.

## Current Scope

This repository is best described as a small platform foundation rather than only a database VM demo. It now includes:
- Private compute for PostgreSQL
- Serverless application hosting with Cloud Run
- Private connectivity between the application and database layers
- Automated post-provisioning with Ansible
- Basic deployment and teardown automation through GitHub Actions

That makes it a stronger base for future work such as secret management, stricter database access rules, application deployment pipelines, and multi-environment promotion.
