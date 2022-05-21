locals {
  docker_compose_release = "2.5.1"
  mumbling_mole_version  = "2.1.0"
}

terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.31.0"
    }
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = "0.11.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.4.0"
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
      version = "~> 2.2.0"
    }
    uptimerobot = {
      source  = "louy/uptimerobot"
      version = "0.5.1"
    }
  }
  required_version = ">= 0.12.26"
  // experiments      = [variable_validation]
}
