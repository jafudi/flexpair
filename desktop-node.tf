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
      "${var.script_dir}/common/update.sh",
      "${var.script_dir}/common/sshd.sh",
      "${var.script_dir}/common/networking.sh",
      "${var.script_dir}/common/sudoers.sh",
      "${var.script_dir}/common/docker-backend.sh"
    ]
  }
}

output "desktop" {
  value = oci_core_instance.desktop.public_ip
}
