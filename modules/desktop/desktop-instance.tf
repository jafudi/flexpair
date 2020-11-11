resource "oci_core_instance" "desktop" {
  availability_domain = var.location_info.data_center_name
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
    ssh_authorized_keys = var.vm_mutual_keypair.public_key_openssh
    user_data           = data.template_cloudinit_config.desktop_config.rendered
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
    timeout = "1m"
  }

  provisioner "remote-exec" {
    inline = [
      "echo Block until cloud-init finished...",
      "set +e",
      "cloud-init status --long --wait",
      "set -e"
    ]
  }
//
//  # Must-haves
//  provisioner "remote-exec" {
//    scripts = [
//      "${path.module}/ssh-remote-exec/install-sshfs-locales.sh",
//      "${path.module}/ssh-remote-exec/lubuntu-desktop.sh",
//      "${path.module}/ssh-remote-exec/lxqt-look-and-feel.sh",
////      "${path.module}/ssh-remote-exec/multiple-languages.sh",
//      "${path.module}/ssh-remote-exec/resource-monitor.sh",
//      "${path.module}/ssh-remote-exec/mumble-pulseaudio.sh",
//      "${path.module}/ssh-remote-exec/desktop-sharing.sh",
//    ]
//    on_failure = fail
//  }
//
//  # Nice-to-haves
//  provisioner "remote-exec" {
//    scripts = [
//      "${path.module}/ssh-remote-exec/podcasts-and-videos.sh",
//    ]
//    on_failure = fail // or continue
//  }
//
  provisioner "remote-exec" {
    inline = [
      "sudo touch /etc/.terraform-complete",
      "sudo cloud-init analyze show",
      "sudo shutdown -r +1"
    ]
  }

}

