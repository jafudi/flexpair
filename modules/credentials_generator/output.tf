output "vm_mutual_key" {
  value = tls_private_key.vm_mutual_key
}

output "email_config" {
  value = local.email_config
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

output "subdomain_label" {
  value = local.valid_subdomain
}

output "full_hostname" {
  value = local.full_hostname
}

output "letsencrypt_certificate" {
  value = acme_certificate.letsencrypt_certificate
}