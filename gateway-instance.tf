variable "gateway_shape" {}

resource "oci_core_instance" "gateway" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.one_per_subdomain.id
  display_name        = "Gateway VM"
  shape               = var.gateway_shape

  freeform_tags = local.compartment_tags

  # Continue only after certificate was successfully issued
  depends_on = [
    acme_certificate.letsencrypt_certificate
  ]

  create_vnic_details {
    subnet_id        = oci_core_subnet.gateway_subnet.id
    display_name     = "ens3"
    assign_public_ip = true
    hostname_label   = "gateway"
    freeform_tags = local.compartment_tags
  }

  source_details {
    source_type = "image" # Ubuntu-20.04-Minimal
    source_id   = data.oci_core_images.ubuntu-20-04-minimal.images.0.id
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.vm_mutual_key.public_key_openssh
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
    private_key = tls_private_key.vm_mutual_key.private_key_pem
  }

  provisioner "file" {
    source      = "upload-directory/"
    destination = "/home/ubuntu/uploads"
  }

}

output "gateway" {
  value = "${oci_core_instance.gateway.public_ip}, domain = ${local.domain}/?password=${local.murmur_password}"
}

