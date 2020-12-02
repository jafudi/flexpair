locals {
  docker_compose_release = "1.27.4"
}

terraform {
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = "~> 2.2.0"
    }
    oci = {
      source  = "hashicorp/oci"
      version = "~> 3.95.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.18"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 2.3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 2.2.0"
    }
    acme = {
      source  = "terraform-providers/acme"
      version = "~> 1.5.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.6.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.12.26"
  // experiments      = [variable_validation]
}

