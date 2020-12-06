locals {
  hostname     = "desktop"
  display_name = title(local.hostname)
}

resource "oci_core_subnet" "desktop_subnet" {
  cidr_block        = "10.1.20.0/24"
  display_name      = "${local.display_name} Subnet"
  dns_label         = "${lower(local.hostname)}net"
  security_list_ids = [var.cloud_provider_context.security_list_id]
  compartment_id    = var.cloud_provider_context.compartment_id
  vcn_id            = var.cloud_provider_context.vcn_id
  route_table_id    = var.cloud_provider_context.route_table_id
  dhcp_options_id   = var.cloud_provider_context.dhcp_options_id

  freeform_tags = var.deployment_tags
}

resource "oci_core_instance" "desktop" {
  availability_domain = var.cloud_provider_context.availability_domain_name
  compartment_id      = var.cloud_provider_context.compartment_id
  display_name        = "${local.display_name} VM"
  shape               = var.cloud_provider_context.minimum_viable_shape

  freeform_tags = var.deployment_tags

  create_vnic_details {
    subnet_id        = oci_core_subnet.desktop_subnet.id
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

  connection {
    type        = "ssh"
    host        = self.public_ip
    port        = 22
    user        = var.desktop_username
    private_key = var.vm_mutual_keypair.private_key_pem
  }

  // Follow the cloud-init logs until finished
  provisioner "remote-exec" {
    inline = [
      "cat /var/log/cloud-init-output.log",
      "tail -f /var/log/cloud-init-output.log | sed '/^.*finished at.*$/ q'",
    ]
    on_failure = continue
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Instance reachable by SSH again after reboot.'",
      "echo 'Waiting for darkstat server to come up...'",
      "until systemctl is-active darkstat; do sleep 5; done"
    ]
  }

}
