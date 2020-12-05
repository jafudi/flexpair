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
  vpc_security_group_ids      = [var.network_config.shared_security_group_id, aws_security_group.gateway_rules.id]
  user_data_base64            = var.encoded_userdata

  connection {
    type        = "ssh"
    host        = self.public_ip
    port        = 22
    user        = var.gateway_username
    private_key = var.vm_mutual_keypair.private_key_pem
  }

//  // Test whether file upload via SSH works
//  provisioner "file" {
//    source      = "${path.root}/uploads/"
//    destination = "/home/${var.gateway_username}/uploads"
//    on_failure  = continue
//  }

  // Follow the cloud-init logs until finished
  provisioner "remote-exec" {
    inline = [
      "cat /var/log/cloud-init-output.log",
      "tail -f /var/log/cloud-init-output.log | sed '/^.*finished at.*$/ q'"
    ]
    on_failure = continue
  }
}

resource "aws_security_group" "gateway_rules" {
  description = "Additional rules for the gateway node"
  vpc_id      = var.network_config.vpc_id

  dynamic "ingress" {
    for_each = var.open_tcp_ports
    iterator = port
    content {
      description = port.key
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "Allow inbound Mumble UDP"
    from_port   = var.open_tcp_ports["mumble"]
    to_port     = var.open_tcp_ports["mumble"]
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.deployment_tags, {
    Name = "gateway_rules"
  })
}