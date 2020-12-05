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
      "tail -f /var/log/cloud-init-output.log | sed '/^.*finished at.*$/ q'",
    ]
    on_failure = continue
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Instance reachable by SSH again after reboot.'",
      "echo 'Waiting for darkstat server to come up...'",
      "until systemctl is-active darkstat; do sleep 5; done"
    ]
  }
}
