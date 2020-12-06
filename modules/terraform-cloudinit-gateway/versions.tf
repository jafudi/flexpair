terraform {
  required_providers {
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
  required_version = ">= 0.12.26"
  // experiments      = [variable_validation]
}
