resource "oci_core_subnet" "gateway_subnet" {
  cidr_block        = "10.1.10.0/24"
  display_name      = "${local.display_name} Subnet"
  dns_label         = "${lower(local.hostname)}net"
  security_list_ids = [oci_core_security_list.gateway_security_list.id]
  compartment_id    = var.compartment.id
  vcn_id            = var.network_config.vcn_id
  route_table_id    = var.network_config.route_table_id
  dhcp_options_id   = var.network_config.dhcp_options_id
  freeform_tags     = var.compartment.freeform_tags
}

resource "oci_core_security_list" "gateway_security_list" {
  compartment_id = var.compartment.id
  vcn_id            = var.network_config.vcn_id
  display_name   = "${local.display_name} Firewall"
  freeform_tags  = var.compartment.freeform_tags

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
      max = "80"
      min = "80"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = var.murmur_config.port
      min = var.murmur_config.port
    }
  }

  ingress_security_rules {
    protocol = "17"
    source   = "0.0.0.0/0"

    udp_options {
      max = var.murmur_config.port
      min = var.murmur_config.port
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = var.email_config.smtp_port
      min = var.email_config.smtp_port
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
