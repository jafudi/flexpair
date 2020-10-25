# https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config

data "cloudinit_config" "desktop_config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-boothook"
    content = templatefile("cloud-init-config/desktop-templates/01-boot-hook.sh", {
      VM_PRIVATE_KEY = tls_private_key.vm_mutual_key.private_key_pem
    })
  }
  part {
    content_type = "text/cloud-config"
    content = templatefile("cloud-init-config/desktop-templates/10-cloud-config.yaml", {
      SSL_DOMAIN       = local.domain
      DESKTOP_TIMEZONE = var.timezone
      DESKTOP_LOCALE   = var.locale
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/desktop-templates/20-shell-script.sh", {
      VM_PRIVATE_KEY    = tls_private_key.vm_mutual_key.private_key_pem
      SSL_DOMAIN        = local.domain
      SUB_DOMAIN_PREFIX = local.subdomain
      EMAIL_ADDRESS     = local.email_address
      IMAP_HOST         = local.domain
      IMAP_PASSWORD     = local.imap_password
      MURMUR_PORT       = var.murmur_port
      MURMUR_PASSWORD   = local.murmur_password
    })
  }
}

output "desktop_config_size" {
  value = length(data.cloudinit_config.desktop_config.rendered)
}