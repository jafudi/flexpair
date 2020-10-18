variable "desktop_shape" {}

variable "gitlab_runner_token" {}

resource "oci_core_instance" "desktop" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.client_workspace.id
  display_name        = "desktop"
  shape               = var.desktop_shape

  # Continue only after certificate was successfully issued
  depends_on = [
    acme_certificate.letsencrypt_certificate
  ]

  create_vnic_details {
    subnet_id        = oci_core_subnet.desktop_subnet.id
    display_name     = "eth0"
    assign_public_ip = true
    hostname_label   = "desktop"
  }

  source_details {
    source_type = "image" # Ubuntu-20.04-Minimal
    source_id   = data.oci_core_images.ubuntu-20-04-minimal.images.0.id
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.vm_mutual_key.public_key_openssh
    user_data           = data.cloudinit_config.desktop_config.rendered
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
    user        = "ubuntu"
    private_key = tls_private_key.vm_mutual_key.private_key_pem
  }

  # Must-haves
  provisioner "remote-exec" {
    scripts = [
      "remote-provision/common/disable-upgrades.sh",
      "remote-provision/common/sshd.sh",
      "remote-provision/desktop/networking.sh",
      "remote-provision/common/sudoers.sh",
      "remote-provision/desktop/lubuntu-desktop.sh",
      "remote-provision/desktop/lxqt-look-and-feel.sh",
      "remote-provision/desktop/multiple-languages.sh",
      "remote-provision/desktop/resource-monitor.sh",
      "remote-provision/desktop/mumble-pulseaudio.sh",
      "remote-provision/desktop/desktop-sharing.sh",
    ]
    on_failure = fail
  }

  # Nice-to-haves
  provisioner "remote-exec" {
    scripts = [
      "remote-provision/desktop/podcasts-and-videos.sh",
      "remote-provision/desktop/edu-games.sh",
      "remote-provision/desktop/mindmap-notes.sh",
      "remote-provision/desktop/office-applications.sh"
    ]
    on_failure = fail // or continue
  }

  provisioner "file" {
    content     = tls_private_key.vm_mutual_key.private_key_pem
    destination = "/home/ubuntu/.ssh/vm_key"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo touch /etc/.terraform-complete",
      "sudo cloud-init clean --logs",
      "sudo shutdown -r +1"
    ]
  }

}

output "desktop" {
  value = "${oci_core_instance.desktop.public_ip} in data center ${data.oci_identity_availability_domain.ad.name}"
}
