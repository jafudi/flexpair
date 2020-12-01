terraform {
  required_providers {
    aws      = "~> 3.18.0"
  }
  required_version = ">= 0.12.26"
  experiments      = [variable_validation]
}