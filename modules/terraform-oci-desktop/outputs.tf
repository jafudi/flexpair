output "public_ip" {
  description = ""
  value       = oci_core_instance.desktop.public_ip
}
