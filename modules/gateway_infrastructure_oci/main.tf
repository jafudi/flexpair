locals {
  hostname = "gateway"
  display_name = title(local.hostname)
}

resource "oci_core_security_list" "gateway_security_list" {
  compartment_id = var.compartment.id
  vcn_id            = var.network_config.vcn_id
  display_name   = "${local.display_name} Firewall"
  freeform_tags  = var.compartment.freeform_tags

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
}

resource "oci_core_subnet" "gateway_subnet" {
  cidr_block        = "10.1.10.0/24"
  display_name      = "${local.display_name} Subnet"
  dns_label         = "${lower(local.hostname)}net"
  security_list_ids = [
    var.network_config.security_list_id,
    oci_core_security_list.gateway_security_list.id
  ]
  compartment_id    = var.compartment.id
  vcn_id            = var.network_config.vcn_id
  route_table_id    = var.network_config.route_table_id
  dhcp_options_id   = var.network_config.dhcp_options_id
  freeform_tags     = var.compartment.freeform_tags
}

resource "oci_core_instance" "gateway" {
  availability_domain = var.location_info.data_center_name
  compartment_id      = var.compartment.id
  display_name        = "${local.display_name} VM"
  shape               = var.vm_specs.compute_shape

  freeform_tags = var.compartment.freeform_tags

  create_vnic_details {
    subnet_id        = oci_core_subnet.gateway_subnet.id
    display_name     = "ens3"
    assign_public_ip = true
    hostname_label   = local.hostname
    freeform_tags    = var.compartment.freeform_tags
  }

  source_details {
    source_type = "image"
    source_id   = var.vm_specs.source_image_id
  }

  metadata = {
    user_data = var.encoded_userdata
  }

  agent_config {
    is_management_disabled = true
    is_monitoring_disabled = true
  }

  // Not needed if all provisioning is done via cloud-init
  connection {
    type        = "ssh"
    host        = self.public_ip
    port        = 22
    user        = var.gateway_username
    private_key = var.vm_mutual_keypair.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "cat /var/log/cloud-init-output.log",
      "tail -f /var/log/cloud-init-output.log | sed '/^.*finished at.*$/ q'"
    ]
    on_failure = continue
  }

  provisioner "file" {
    source      = "${path.root}/uploads/"
    destination = "/home/${var.gateway_username}/uploads"
    on_failure  = continue
  }

}


