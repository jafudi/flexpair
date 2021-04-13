terraform {
  required_providers {
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
  }
  required_version = ">= 0.12.26"
  // experiments      = [variable_validation]
}
