# https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config

data "template_cloudinit_config" "desktop_config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-boothook"
    content = templatefile("${path.module}/init-scripts/01-private-key-etc.sh", {
      VM_PRIVATE_KEY = var.vm_mutual_keypair.private_key_pem
    })
  }
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/init-scripts/10-cloud-config.yaml", {
      SSL_DOMAIN       = var.url.full_hostname
      DESKTOP_TIMEZONE = var.location_info.timezone_name
      DESKTOP_LOCALE   = var.location_info.locale_settings
    })
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/init-scripts/11-sudoers.sh")
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/20-ssh-tunnel.sh", {
      SSL_DOMAIN        = var.url.full_hostname
      MURMUR_PORT       = var.murmur_config.port
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/30-mumble-client.sh", {
      SSL_DOMAIN        = var.url.full_hostname
      MURMUR_PORT       = var.murmur_config.port
      MURMUR_PASSWORD   = var.murmur_config.password
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/40-trojita-mail.sh", {
      SUB_DOMAIN_PREFIX = var.url.subdomain_label
      EMAIL_ADDRESS     = var.email_config.address
      IMAP_PASSWORD     = var.email_config.password
    })
  }
}
