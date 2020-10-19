# get latest Ubuntu Linux 20.04 Minimal image
# https://docs.cloud.oracle.com/en-us/iaas/images/ubuntu-2004/
data "oci_core_images" "ubuntu-20-04-minimal" {
  compartment_id = oci_identity_compartment.one_per_subdomain.id
  filter {
    name   = "display_name"
    values = ["^Canonical-Ubuntu-20.04-Minimal-([\\.0-9-]+)$"]
    regex  = true
  }
  sort_by    = "TIMECREATED"
  sort_order = "DESC"
}

output "ubuntu-20-04-minimal-latest" {
  value = data.oci_core_images.ubuntu-20-04-minimal.images.0.display_name
}

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

