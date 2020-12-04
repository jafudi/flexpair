resource "tls_private_key" "vm_mutual_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "random_password" "imap_password" {
  length  = 16
  special = false // may lead to quoting issues otherwise
}

resource "random_password" "murmur_password" {
  length  = 16
  special = false // may lead to quoting issues otherwise
}

resource "random_integer" "murmur_port" {
  max = 65535
  min = 10000
}

locals {
  murmur_credentials = {
    port     = random_integer.murmur_port.result
    password = random_password.murmur_password.result
  }
}