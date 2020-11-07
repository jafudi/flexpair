output "used_base_image" {
  value = data.oci_core_images.ubuntu-20-04-minimal.images.0.display_name
}

output "gateway_in_browser" {
  value = module.gateway.access_url
}

locals {
  working_dir = "/Users/jens/PycharmProjects/traction"
}

output "ssh_into_desktop" {
  value = "ssh -i ${local.working_dir}/.ssh/privkey -o StrictHostKeyChecking=no ${var.desktop_username}@${module.desktop_1.public_ip}"
}

output "private_key" {
  value = tls_private_key.vm_mutual_key.private_key_pem
}

output "gateway_userdata" {
  value = "${module.gateway.userdata_bytes} bytes"
}

output "desktop_userdata" {
  value = "${module.desktop_1.userdata_bytes} bytes"
}