locals {
  hostname     = "gateway"
  display_name = title(local.hostname)
  tags = merge(var.compartment.freeform_tags, {
    Name = local.display_name
  })
}

resource "aws_instance" "gateway" {
  ami           = var.vm_specs.source_image_id
  instance_type = var.vm_specs.compute_shape
  associate_public_ip_address = true
  tags        = local.tags
  volume_tags = local.tags
  monitoring = false
  subnet_id = var.network_config.subnet_id
  vpc_security_group_ids = var.network_config.vpc_security_group_ids
}
