locals {
  hostname = "gateway"
  display_name = title(local.hostname)
}

resource "aws_instance" "gateway" {
  ami           = var.vm_specs.source_image_id
  instance_type = var.vm_specs.compute_shape

  tags = {
    Name = local.display_name
  }
}