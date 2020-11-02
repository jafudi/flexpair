resource "oci_core_virtual_network" "main_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = oci_identity_compartment.one_per_subdomain.id
  display_name   = "Main Virtual Cloud Network"
  dns_label      = "mainvcn"
  freeform_tags  = local.compartment_tags
}

resource "oci_core_internet_gateway" "common_internet_gateway" {
  compartment_id = oci_identity_compartment.one_per_subdomain.id
  display_name   = "Common Internet Gateway"
  vcn_id         = oci_core_virtual_network.main_vcn.id
  freeform_tags  = local.compartment_tags
}

resource "oci_core_route_table" "common_route_table" {
  compartment_id = oci_identity_compartment.one_per_subdomain.id
  vcn_id         = oci_core_virtual_network.main_vcn.id
  display_name   = "Common Route Table"
  freeform_tags  = local.compartment_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.common_internet_gateway.id
  }
}

locals {
  network_config = {
    vcn_id          = oci_core_virtual_network.main_vcn.id
    route_table_id  = oci_core_route_table.common_route_table.id
    dhcp_options_id = oci_core_virtual_network.main_vcn.default_dhcp_options_id
  }
}


