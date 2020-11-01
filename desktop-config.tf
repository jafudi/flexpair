# https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config

data "template_cloudinit_config" "desktop_config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-boothook"
    content = templatefile("cloud-init-config/desktop-templates/01-private-key-etc.sh", {
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
    content      = file("cloud-init-config/desktop-templates/11-sudoers.sh")
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/desktop-templates/20-ssh-tunnel.sh", {
      SSL_DOMAIN        = local.domain
      MURMUR_PORT       = var.murmur_port
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/desktop-templates/30-mumble-client.sh", {
      SSL_DOMAIN        = local.domain
      MURMUR_PORT       = var.murmur_port
      MURMUR_PASSWORD   = local.murmur_password
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/desktop-templates/40-trojita-mail.sh", {
      SUB_DOMAIN_PREFIX = local.subdomain
      EMAIL_ADDRESS     = local.email_address
      IMAP_PASSWORD     = local.imap_password
    })
  }
}
