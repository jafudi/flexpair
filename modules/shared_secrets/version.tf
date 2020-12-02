terraform {
  required_providers {
    random   = "~> 2.3.0"
    tls      = "~> 2.2.0"
  }
  required_version = ">= 0.12.26"
  // experiments      = [variable_validation]
}