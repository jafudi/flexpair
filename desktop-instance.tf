variable "desktop_shape" {}

variable "gitlab_runner_token" {}

resource "oci_core_instance" "desktop" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.one_per_subdomain.id
  display_name        = "Desktop VM"
  shape               = var.desktop_shape

  freeform_tags = local.compartment_tags

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

  provisioner "remote-exec" {
    inline = [
      "echo Block until cloud-init finished...",
      "set +e",
      "cloud-init status --long --wait",
      "set -e"
    ]
  }

  # Must-haves
  provisioner "remote-exec" {
    scripts = [
      "desktop-scripts/disable-upgrades.sh",
      "desktop-scripts/sshd.sh",
      "desktop-scripts/networking.sh",
      "desktop-scripts/sudoers.sh",
      "desktop-scripts/lubuntu-desktop.sh",
      "desktop-scripts/lxqt-look-and-feel.sh",
      "desktop-scripts/multiple-languages.sh",
      "desktop-scripts/resource-monitor.sh",
      "desktop-scripts/mumble-pulseaudio.sh",
      "desktop-scripts/desktop-sharing.sh",
    ]
    on_failure = fail
  }

  # Nice-to-haves
  provisioner "remote-exec" {
    scripts = [
      "desktop-scripts/podcasts-and-videos.sh",
    ]
    on_failure = fail // or continue
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
