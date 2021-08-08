locals {
  docker_compose_release = "1.28.6"
  mumbling_mole_version  = "latest"
}

terraform {
  required_providers {
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = "0.6.0"
    }
    oci = {
      source  = "hashicorp/oci"
      version = "~> 3.95.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1.0"
    }
    acme = {
      source  = "terraform-providers/acme"
      version = "~> 2.4.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.7.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }
  }
  required_version = ">= 0.12.26"
  // experiments      = [variable_validation]
}
