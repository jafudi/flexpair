output "vm_mutual_key" {
  value = tls_private_key.vm_mutual_key
}

output "imap_password" {
  value = random_password.imap_password.result
}

output "murmur_password" {
  value = random_password.murmur_password.result
}