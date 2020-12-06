terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.18"
    }
  }
  required_version = ">= 0.12.26"
  // experiments      = [variable_validation]
}