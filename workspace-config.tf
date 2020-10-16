terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "jafudi"

    workspaces {
      name = "branch-dns01"
    }
  }

  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = "~> 2.2.0"
    }
    oci = {
      source  = "hashicorp/oci"
      version = "~> 3.95.0"
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
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.0.0"
    }
  }
  required_version = ">= 0.13"
}

