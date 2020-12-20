locals {
  hostname     = "gateway"
  display_name = title(local.hostname)
  tags = merge(var.deployment_tags, {
    Name = local.display_name
  })
}

resource "aws_instance" "gateway" {
  ami                         = var.cloud_provider_context.source_image_id
  instance_type               = var.cloud_provider_context.minimum_viable_shape
  associate_public_ip_address = true
  tags                        = local.tags
  volume_tags                 = local.tags
  monitoring                  = false
  subnet_id                   = var.cloud_provider_context.subnet_id
  vpc_security_group_ids      = [var.cloud_provider_context.shared_security_group_id, aws_security_group.gateway_rules.id]
  user_data_base64            = var.encoded_userdata

  connection {
    type        = "ssh"
    host        = self.public_ip
    port        = 22
    user        = var.gateway_username
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

  // Check that vital services are up and running
  provisioner "remote-exec" {
    inline = [
      "echo 'Checking that docker-compose.service is active...'",
      "until systemctl is-active docker-compose.service; do sleep 1; done",
      "echo 'Checking that docker.service is active...'",
      "until systemctl is-active docker.service; do sleep 1; done",
      "echo 'Checking that containerd.service is active...'",
      "until systemctl is-active containerd.service; do sleep 1; done"
    ]
    on_failure = fail
  }
}

resource "aws_security_group" "gateway_rules" {
  description = "Additional rules for the gateway node"
  vpc_id      = var.cloud_provider_context.vpc_id

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
