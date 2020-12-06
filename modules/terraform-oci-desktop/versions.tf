terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "~> 3.95.0"
    }
  }
  required_version = ">= 0.12.26"
  // experiments      = [variable_validation]
}
