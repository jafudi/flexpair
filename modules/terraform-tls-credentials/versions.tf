terraform {
  required_providers {
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
  }
  required_version = ">= 0.12.26"
  // experiments      = [variable_validation]
}
