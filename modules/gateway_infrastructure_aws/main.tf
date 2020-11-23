locals {
  hostname     = "gateway"
  display_name = title(local.hostname)
  tags = merge(var.deployment_tags, {
    Name = local.display_name
  })
}

resource "aws_instance" "gateway" {
  ami                         = var.vm_specs.source_image_id
  instance_type               = var.vm_specs.compute_shape
  associate_public_ip_address = true
  tags                        = local.tags
  volume_tags                 = local.tags
  monitoring                  = false
  subnet_id                   = var.network_config.subnet_id
  vpc_security_group_ids      = var.network_config.vpc_security_group_ids

  connection {
    type        = "ssh"
    host        = self.public_ip
    port        = 22
    user        = var.gateway_username
    private_key = var.vm_mutual_keypair.private_key_pem
    timeout     = "30s"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /var/log/cloud-init-output.log",
      "tail -f /var/log/cloud-init-output.log | sed '/^.*finished at.*$/ q'"
    ]
    on_failure = continue
  }

  provisioner "file" {
    source      = "${path.root}/uploads/"
    destination = "/home/${var.gateway_username}/uploads"
    on_failure  = continue
  }
}
