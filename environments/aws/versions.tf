locals {
  docker_compose_release = "2.6.0"
  mumbling_mole_version  = "3.2.1"
}

terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.31.0"
    }
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = "1.7.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.66"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.0"
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
      version = "~> 2.5.0"
    }
    uptimerobot = {
      source  = "louy/uptimerobot"
      version = "0.5.1"
    }
  }
  required_version = "~> 1.5.0"
}
