variable "gitlab_runner_token" {}

resource "oci_core_instance" "desktop" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.client_workspace.id
  display_name        = "desktop"
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id        = oci_core_subnet.desktop_subnet.id
    display_name     = "eth0"
    assign_public_ip = true
    hostname_label   = "desktop"
  }

  source_details {
    source_type = "image"
    source_id   = var.images[var.region]
  }

  metadata = {
    ssh_authorized_keys = var.vm_public_key
    user_data = templatefile("cloud-init/desktop-userdata.tpl", {
      SSL_DOMAIN = local.domain
      SUB_DOMAIN_PREFIX = var.target_subdomain
      REGISTERED_DOMAIN = var.dns_zone_name
      EMAIL_ADDRESS = local.email_address
      IMAP_HOST = local.domain
      IMAP_PASSWORD = var.imap_password
      MURMUR_PORT = var.murmur_port
      MURMUR_PASSWORD = var.murmur_password
    })
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
    private_key = var.vm_private_key
  }

  provisioner "file" {
      content = var.vm_private_key
      destination = "/var/tmp/ssh/vm_key"
  }

  provisioner "remote-exec" {
    scripts = [
      "${var.script_dir}/common/update.sh",
      "${var.script_dir}/common/sshd.sh",
      "${var.script_dir}/common/networking.sh",
      "${var.script_dir}/common/sudoers.sh",
      "${var.script_dir}/common/docker-backend.sh",
      "${var.script_dir}/desktop/lubuntu-desktop.sh",
      "${var.script_dir}/desktop/lxqt-look-and-feel.sh",
      "${var.script_dir}/desktop/multiple-languages.sh",
      "${var.script_dir}/desktop/meteo-qt.sh",
      "${var.script_dir}/desktop/podcasts-and-videos.sh",
      "${var.script_dir}/desktop/resource-monitor.sh",
      "${var.script_dir}/desktop/mumble-pulseaudio.sh",
      "${var.script_dir}/desktop/desktop-sharing.sh",
      "${var.script_dir}/desktop/edu-games.sh",
      "${var.script_dir}/desktop/mindmap-notes.sh",
      "${var.script_dir}/desktop/office-applications.sh"
    ]
  }

  provisioner "file" {
      source = "packer-desktop/vartmp-uploads/desktop/"
      destination = "/var/tmp/"
  }

  provisioner "file" {
      source = "packer-desktop/desktop-home-uploads/"
      destination = "/home/ubuntu/uploads/"
  }

}

output "desktop" {
  value = oci_core_instance.desktop.public_ip
}
