output "subdomain_label" {
  value = local.valid_subdomain
}

output "full_hostname" {
  value = local.full_hostname
}

output "certificate" {
  value = acme_certificate.letsencrypt_certificate
}