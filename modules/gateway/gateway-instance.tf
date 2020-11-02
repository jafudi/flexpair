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
    ssh_authorized_keys = var.vm_mutual_keypair.public_key_openssh
    user_data           = data.template_cloudinit_config.gateway_config.rendered
  }

  agent_config {
    is_management_disabled = true
    is_monitoring_disabled = true
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    port        = 22
    user        = "ubuntu"
    private_key = var.vm_mutual_keypair.private_key_pem
  }

  provisioner "file" {
    source      = "${path.module}/upload-directory/"
    destination = "/home/ubuntu/uploads"
  }

}

