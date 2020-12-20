locals {
  hostname     = "desktop"
  display_name = title(local.hostname)
  tags = merge(var.deployment_tags, {
    Name = local.display_name
  })
}

resource "aws_instance" "desktop" {
  ami                         = var.cloud_provider_context.source_image_id
  instance_type               = var.cloud_provider_context.minimum_viable_shape
  associate_public_ip_address = true
  tags                        = local.tags
  volume_tags                 = local.tags
  monitoring                  = false
  subnet_id                   = var.cloud_provider_context.subnet_id
  vpc_security_group_ids      = [var.cloud_provider_context.shared_security_group_id]
  user_data_base64            = var.encoded_userdata

  connection {
    type        = "ssh"
    host        = self.public_ip
    port        = 22
    user        = var.desktop_username
    private_key = var.vm_mutual_keypair.private_key_pem
  }

  // Follow the cloud-init logs until finished
  provisioner "remote-exec" {
    inline = [
      "cat /var/log/cloud-init-output.log",
      "tail -f /var/log/cloud-init-output.log | sed '/^.*finished at.*$/ q'"
    ]
    on_failure = continue
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

  // Check that vital services are up and running
  provisioner "remote-exec" {
    inline = [
      "echo 'Instance reachable by SSH again after reboot.'",
      "echo 'Checking that x11vnc.service is active...'",
      "until systemctl is-active x11vnc.service; do sleep 1; done",
      "echo 'Checking that darkstat.service is active...'",
      "until systemctl is-active darkstat.service; do sleep 1; done",
      "echo 'Checking that home-${var.desktop_username}-Desktop-Uploads.mount is active...'",
      "until systemctl is-active home-${var.desktop_username}-Desktop-Uploads.mount; do sleep 1; done",
      "echo 'Checking that ssh-tunnel.service is active...'",
      "until systemctl is-active ssh-tunnel.service; do sleep 1; done",
      "echo 'Checking that nohang-desktop.service is active...'",
      "until systemctl is-active nohang-desktop.service; do sleep 1; done"
    ]
    on_failure = fail
  }
}
