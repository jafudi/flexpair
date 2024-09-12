terraform {
  required_providers {
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
  }
  required_version = "~> 1.5.0"
}
