terraform {
  required_providers {
    acme = {
      source  = "terraform-providers/acme"
      version = "~> 1.5.0"
    }
  }
  required_version = ">= 0.13"
}

