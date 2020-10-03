variable "gitlab_runner_token" {}

resource "oci_core_instance" "desktop" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.client_workspace.id
  display_name        = "desktop"
  shape               = "VM.Standard.E2.1.Micro"
  # Processor: 1/8th of an AMD EPYC 7551
  # Base frequency: 2.0 GHz, max boost frequency: 3.0 GHz
  # Memory: 1 GB
  # Bandwidth: 480 Mbps
  # Boot Volume Size: 50 GB

  create_vnic_details {
    subnet_id        = oci_core_subnet.desktop_subnet.id
    display_name     = "eth0"
    assign_public_ip = true
    hostname_label   = "desktop"
  }

  source_details {
    source_type = "image" # Ubuntu-20.04-Minimal
    source_id   = var.images[var.region]
  }

  metadata = {
    ssh_authorized_keys = var.vm_public_key
    user_data = base64encode(templatefile("cloud-init/desktop-userdata.tpl", {
      SSL_DOMAIN = local.domain
      SUB_DOMAIN_PREFIX = var.target_subdomain
      EMAIL_ADDRESS = local.email_address
      IMAP_HOST = local.domain
      IMAP_PASSWORD = var.imap_password
      MURMUR_PORT = var.murmur_port
      MURMUR_PASSWORD = var.murmur_password
    }))
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

  provisioner "remote-exec" {
    scripts = [
      "${local.script_dir}/common/update.sh",
      "${local.script_dir}/common/sshd.sh",
      "${local.script_dir}/desktop/networking.sh",
      "${local.script_dir}/common/sudoers.sh",
      "${local.script_dir}/common/docker-backend.sh",
      "${local.script_dir}/desktop/lubuntu-desktop.sh",
      "${local.script_dir}/desktop/lxqt-look-and-feel.sh",
      "${local.script_dir}/desktop/multiple-languages.sh",
      "${local.script_dir}/desktop/podcasts-and-videos.sh",
      "${local.script_dir}/desktop/resource-monitor.sh",
      "${local.script_dir}/desktop/mumble-pulseaudio.sh",
      "${local.script_dir}/desktop/desktop-sharing.sh",
      "${local.script_dir}/desktop/edu-games.sh",
      "${local.script_dir}/desktop/mindmap-notes.sh",
      "${local.script_dir}/desktop/office-applications.sh"
    ]
  }

  provisioner "file" {
      content = var.vm_private_key
      destination = "/home/ubuntu/.ssh/vm_key"
  }

  provisioner "file" {
      source = "packer-desktop/vartmp-uploads/desktop/"
      destination = "/var/tmp"
  }

  provisioner "file" {
      source = "packer-desktop/desktop-home-uploads/"
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

output "desktop" {
  value = "${oci_core_instance.desktop.public_ip} in data center ${data.oci_identity_availability_domain.ad.name}"
}
