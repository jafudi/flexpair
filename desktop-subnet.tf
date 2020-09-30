resource "oci_core_subnet" "desktop_subnet" {
  cidr_block        = "10.1.20.0/24"
  display_name      = "Desktop Subnet"
  dns_label         = "desktopnet"
  security_list_ids = [oci_core_security_list.desktop_security_list.id]
  compartment_id    = oci_identity_compartment.client_workspace.id
  vcn_id            = oci_core_virtual_network.main_vcn.id
  route_table_id    = oci_core_route_table.common_route_table.id
  dhcp_options_id   = oci_core_virtual_network.main_vcn.default_dhcp_options_id
}

resource "oci_core_security_list" "desktop_security_list" {
  compartment_id = oci_identity_compartment.client_workspace.id
  vcn_id         = oci_core_virtual_network.main_vcn.id
  display_name   = "Desktop Firewall"

  egress_security_rules {
    protocol    = "6"
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
      max = "5060"
      min = "5060"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "7078"
      min = "7078"
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