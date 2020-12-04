output "vm_mutual_key" {
  value = tls_private_key.vm_mutual_key
}

output "imap_password" {
  value = random_password.imap_password.result
}

output "murmur_credentials" {
  value = local.murmur_credentials
}

output "gateway_username" {
  value = var.gateway_username
}

output "desktop_username" {
  value = var.desktop_username
}