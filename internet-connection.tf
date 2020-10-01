variable "dns_zone_name" {}

variable "target_subdomain" {}

variable "vm_public_key" {}

variable "vm_private_key" {}

variable "murmur_port" {}

variable "murmur_password" {}

variable "imap_password" {}

variable "mailbox_prefix" {}

locals {
    domain = "${var.target_subdomain}.${var.dns_zone_name}"
    email_address = "${var.mailbox_prefix}@${local.domain}"
}

resource "oci_dns_zone" "test_zone" {
    compartment_id = oci_identity_compartment.client_workspace.id
    name = var.dns_zone_name
    zone_type = "PRIMARY"
}

resource "oci_dns_record" "A_record" {
    compartment_id = oci_dns_zone.test_zone.compartment_id
    zone_name_or_id = var.dns_zone_name
    domain = local.domain
    rtype = "A"
    rdata = oci_core_instance.gateway.public_ip
    ttl = 300
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
