output "public_ip" {
  description = ""
  value       = aws_instance.desktop.public_ip
}
