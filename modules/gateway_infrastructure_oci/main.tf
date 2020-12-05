locals {
  hostname     = "gateway"
  display_name = title(local.hostname)
}

resource "oci_core_security_list" "gateway_security_list" {
  compartment_id = var.cloud_provider_context.compartment_id
  vcn_id         = var.cloud_provider_context.vcn_id
  display_name   = "${local.display_name} Firewall"
  freeform_tags  = var.deployment_tags

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
    var.cloud_provider_context.security_list_id,
    oci_core_security_list.gateway_security_list.id
  ]
  compartment_id  = var.cloud_provider_context.compartment_id
  vcn_id          = var.cloud_provider_context.vcn_id
  route_table_id  = var.cloud_provider_context.route_table_id
  dhcp_options_id = var.cloud_provider_context.dhcp_options_id
  freeform_tags   = var.deployment_tags
}

resource "oci_core_instance" "gateway" {
  availability_domain = var.cloud_provider_context.availability_domain_name
  compartment_id      = var.cloud_provider_context.compartment_id
  display_name        = "${local.display_name} VM"
  shape               = var.cloud_provider_context.minimum_viable_shape

  freeform_tags = var.deployment_tags

  create_vnic_details {
    subnet_id        = oci_core_subnet.gateway_subnet.id
    display_name     = "ens3"
    assign_public_ip = true
    hostname_label   = local.hostname
    freeform_tags    = var.deployment_tags
  }

  source_details {
    source_type = "image"
    source_id   = var.cloud_provider_context.source_image_id
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


