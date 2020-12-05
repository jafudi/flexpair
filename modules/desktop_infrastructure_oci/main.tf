locals {
  hostname     = "desktop"
  display_name = title(local.hostname)
}

resource "oci_core_subnet" "desktop_subnet" {
  cidr_block        = "10.1.20.0/24"
  display_name      = "${local.display_name} Subnet"
  dns_label         = "${lower(local.hostname)}net"
  security_list_ids = [var.network_config.security_list_id]
  compartment_id    = var.compartment.id
  vcn_id            = var.network_config.vcn_id
  route_table_id    = var.network_config.route_table_id
  dhcp_options_id   = var.network_config.dhcp_options_id

  freeform_tags = var.compartment.freeform_tags
}

resource "oci_core_instance" "desktop" {
  availability_domain = var.oci_availability_zone
  compartment_id      = var.compartment.id
  display_name        = "${local.display_name} VM"
  shape               = var.vm_specs.compute_shape

  freeform_tags = var.compartment.freeform_tags

  create_vnic_details {
    subnet_id        = oci_core_subnet.desktop_subnet.id
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
    user_data           = var.encoded_userdata
    gitlab_runner_token = var.gitlab_runner_token
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

  provisioner "remote-exec" {
    inline = [
      "cat /var/log/cloud-init-output.log",
      "tail -f /var/log/cloud-init-output.log | sed '/^.*finished at.*$/ q'",
    ]
    on_failure = continue
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Instance reachable by SSH again after reboot.'",
      "echo 'Waiting for darkstat server to come up...'",
      "until systemctl is-active darkstat; do sleep 5; done"
    ]
  }

}
