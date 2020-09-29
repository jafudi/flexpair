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
}

/*resource "oci_core_instance" "desktop" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.client_workspace.id
  display_name        = "desktop"
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id        = oci_core_subnet.desktop_subnet.id
    display_name     = "eth0"
    assign_public_ip = true
    hostname_label   = "desktop"
  }

  source_details {
    source_type = "image"
    source_id   = var.images[var.region]
  }

  metadata = {
    ssh_authorized_keys = var.vm_public_key
  }

  agent_config {
    is_management_disabled = true
    is_monitoring_disabled = true
  }
}

data "oci_core_instance" "desktop" {
    instance_id = oci_core_instance.desktop.id
}

output "desktop" {
  value = "http://${data.oci_core_instance.desktop.public_ip}"
}*/
