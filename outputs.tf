output "used_base_image" {
  value = data.oci_core_images.ubuntu-20-04-minimal.images.0.display_name
}

output "gateway_in_browser" {
  value = module.gateway.access_url
}

output "ssh_into_desktop" {
  value = "ssh -i ${abspath(path.root)}/.ssh/privkey -o StrictHostKeyChecking=no ubuntu@${module.desktop_1.public_ip}"
}

ouptut "private_key" {
  value = tls_private_key.vm_mutual_key.private_key_pem
}