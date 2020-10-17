resource "oci_core_subnet" "gateway_subnet" {
  cidr_block        = "10.1.10.0/24"
  display_name      = "Gateway Subnet"
  dns_label         = "gatewaynet"
  security_list_ids = [oci_core_security_list.gateway_security_list.id]
  compartment_id    = oci_identity_compartment.client_workspace.id
  vcn_id            = oci_core_virtual_network.main_vcn.id
  route_table_id    = oci_core_route_table.common_route_table.id
  dhcp_options_id   = oci_core_virtual_network.main_vcn.default_dhcp_options_id
}

resource "oci_core_security_list" "gateway_security_list" {
  compartment_id = oci_identity_compartment.client_workspace.id
  vcn_id         = oci_core_virtual_network.main_vcn.id
  display_name   = "Gateway Firewall"

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "443"
      min = "443"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "64738"
      min = "64738"
    }
  }

  ingress_security_rules {
    protocol = "17"
    source   = "0.0.0.0/0"

    udp_options {
      max = "64738"
      min = "64738"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "25"
      min = "25"
    }
  }

  ingress_security_rules {
    protocol = "1"
    source   = "0.0.0.0/0"

    icmp_options {
      type = "8" // Echo requests (used to ping)
    }
  }

  ingress_security_rules {
    protocol = "1"
    source   = "0.0.0.0/0"

    icmp_options {
      type = "3" // Destination Unreachable
    }
  }
}
