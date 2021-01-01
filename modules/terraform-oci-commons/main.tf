data "oci_identity_tenancy" "te" {
  tenancy_id = var.tenancy_ocid
}

resource "oci_identity_compartment" "one_per_subdomain" {
  compartment_id = var.tenancy_ocid
  description    = "Setting compartment label equal to subdomain label"
  name           = var.compartment_name
  freeform_tags  = var.deployment_tags
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.availibility_domain_number
}

resource "oci_core_virtual_network" "main_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = oci_identity_compartment.one_per_subdomain.id
  display_name   = "Main Virtual Cloud Network"
  dns_label      = "mainvcn"
  freeform_tags  = var.deployment_tags
}

resource "oci_core_internet_gateway" "common_internet_gateway" {
  compartment_id = oci_identity_compartment.one_per_subdomain.id
  display_name   = "Common Internet Gateway"
  vcn_id         = oci_core_virtual_network.main_vcn.id
  freeform_tags  = var.deployment_tags
}

resource "oci_core_route_table" "common_route_table" {
  compartment_id = oci_identity_compartment.one_per_subdomain.id
  vcn_id         = oci_core_virtual_network.main_vcn.id
  display_name   = "Common Route Table"
  freeform_tags  = var.deployment_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.common_internet_gateway.id
  }
}

resource "oci_core_security_list" "shared_security_list" {
  compartment_id = oci_identity_compartment.one_per_subdomain.id
  vcn_id         = oci_core_virtual_network.main_vcn.id
  display_name   = "Shared Firewall"
  freeform_tags  = var.deployment_tags

  // Outbound connections via any protocol
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  // Inbound SSH connections
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  // Echo requests (used to ping)
  ingress_security_rules {
    protocol = "1"
    source   = "0.0.0.0/0"

    icmp_options {
      type = "8"
    }
  }

  // Destination unreachable messages
  ingress_security_rules {
    protocol = "1"
    source   = "0.0.0.0/0"

    icmp_options {
      type = "3"
    }
  }
}

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
