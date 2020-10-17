variable "murmur_port" {}

variable "mailbox_prefix" {}

variable "TFC_CONFIGURATION_VERSION_GIT_COMMIT_SHA" {
  // https://www.terraform.io/docs/cloud/run/run-environment.html#environment-variables
}

resource "tls_private_key" "vm_mutual_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "random_string" "imap_password" {
  length  = 16
  special = true
  keepers = {
    # Generate a new password each time we change the web address
    user_facing_web_address = local.domain
  }
}

resource "random_string" "murmur_password" {
  length  = 16
  special = false
  keepers = {
    # Generate a new password each time we change the web address
    user_facing_web_address = local.domain
  }
}

locals {
  email_address   = "${var.mailbox_prefix}@${local.domain}"
  imap_password   = random_string.imap_password.result
  murmur_password = random_string.murmur_password.result
}

resource "oci_core_virtual_network" "main_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = oci_identity_compartment.client_workspace.id
  display_name   = "Main Virtual Cloud Network"
  dns_label      = "mainvcn"
}

resource "oci_core_internet_gateway" "common_internet_gateway" {
  compartment_id = oci_identity_compartment.client_workspace.id
  display_name   = "Common Internet Gateway"
  vcn_id         = oci_core_virtual_network.main_vcn.id
}

resource "oci_core_route_table" "common_route_table" {
  compartment_id = oci_identity_compartment.client_workspace.id
  vcn_id         = oci_core_virtual_network.main_vcn.id
  display_name   = "Common Route Table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.common_internet_gateway.id
  }
}

output "private_key" {
  value       = tls_private_key.vm_mutual_key.private_key_pem
  description = "Private key for connecting to either of the VMs as user 'ubuntu' via SSH"
  sensitive   = true
}
