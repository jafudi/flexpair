locals {
  hostname     = "gateway"
  display_name = title(local.hostname)
}

resource "oci_core_security_list" "gateway_security_list" {
  compartment_id = var.compartment.id
  vcn_id         = var.network_config.vcn_id
  display_name   = "${local.display_name} Firewall"
  freeform_tags  = var.compartment.freeform_tags

  dynamic "ingress_security_rules" {
    for_each = var.open_tcp_ports
    iterator = port
    content {
      protocol    = "6"
      source      = "0.0.0.0/0"
      description = port.key
      tcp_options {
        max = port.value
        min = port.value
      }
    }
  }

  ingress_security_rules {
    protocol    = "17"
    source      = "0.0.0.0/0"
    description = "Mumble incoming via UDP"
    udp_options {
      max = var.open_tcp_ports["mumble"]
      min = var.open_tcp_ports["mumble"]
    }
  }

}

resource "oci_core_subnet" "gateway_subnet" {
  cidr_block   = "10.1.10.0/24"
  display_name = "${local.display_name} Subnet"
  dns_label    = "${lower(local.hostname)}net"
  security_list_ids = [
    var.network_config.security_list_id,
    oci_core_security_list.gateway_security_list.id
  ]
  compartment_id  = var.compartment.id
  vcn_id          = var.network_config.vcn_id
  route_table_id  = var.network_config.route_table_id
  dhcp_options_id = var.network_config.dhcp_options_id
  freeform_tags   = var.compartment.freeform_tags
}

resource "oci_core_instance" "gateway" {
  availability_domain = var.oci_availability_zone
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

  // Follow the cloud-init logs until finished
  provisioner "remote-exec" {
    inline = [
      "cat /var/log/cloud-init-output.log",
      "tail -f /var/log/cloud-init-output.log | sed '/^.*finished at.*$/ q'"
    ]
    on_failure = continue
  }

  // Test whether file upload via SSH works
  provisioner "file" {
    source      = "${path.root}/uploads/"
    destination = "/home/${var.gateway_username}/uploads"
    on_failure  = fail
  }

}


