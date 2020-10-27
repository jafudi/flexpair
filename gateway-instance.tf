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
    display_name     = "eth0"
    assign_public_ip = true
    hostname_label   = "gateway"
  }

  source_details {
    source_type = "image" # Ubuntu-20.04-Minimal
    source_id   = data.oci_core_images.ubuntu-20-04-minimal.images.0.id
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.vm_mutual_key.public_key_openssh
    user_data           = data.cloudinit_config.gateway_config.rendered
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

  provisioner "remote-exec" {
    inline = [
      "echo Block until cloud-init finished...",
      "set +e",
      "cloud-init status --long --wait",
      "set -e"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.docker_compose_folder}",
      "sudo chown -R ubuntu ${local.docker_compose_folder}"
    ]
  }
  provisioner "file" {
    source      = "docker-compose/"
    destination = local.docker_compose_folder
  }

  provisioner "file" {
    source      = "upload-directory/"
    destination = "/home/ubuntu/uploads"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo touch /etc/.terraform-complete",
      "sudo cloud-init clean --logs",
      "sudo shutdown -r +1"
    ]
  }

}

output "gateway" {
  value = "${oci_core_instance.gateway.public_ip}, domain = ${local.domain}/?password=${local.murmur_password}"
}

