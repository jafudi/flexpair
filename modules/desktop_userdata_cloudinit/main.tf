# https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config

data "template_cloudinit_config" "desktop_config" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-boothook"
    content      = file("${path.module}/init-scripts/01-welcome-message.sh")
  }
  part {
    content_type = "text/cloud-boothook"
    content      = file("${path.module}/init-scripts/02-disable-upgrades.sh")
  }
  part {
    content_type = "text/cloud-boothook"
    content      = file("${path.module}/init-scripts/03-sshd-config.sh")
  }
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/init-scripts/10-cloud-config.yaml", {
      SSL_DOMAIN       = var.gateway_dns_hostname
      DESKTOP_TIMEZONE = var.location_info.timezone_name
      DESKTOP_LOCALE   = var.location_info.locale_settings
      DESKTOP_USERNAME = var.desktop_username
      GATEWAY_USERNAME = var.gateway_username
      SSH_PUBLIC_KEY   = var.vm_mutual_keypair.public_key_openssh
    })
  }
  part {
    content_type = "text/cloud-boothook"
    content = templatefile("${path.module}/init-scripts/11-add-privkey.sh", {
      VM_PRIVATE_KEY   = var.vm_mutual_keypair.private_key_pem
      DESKTOP_USERNAME = var.desktop_username
    })
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/init-scripts/15-install-packages.sh")
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/20-ssh-tunnel.sh", {
      SSL_DOMAIN       = var.gateway_dns_hostname
      MURMUR_PORT      = var.murmur_config.port
      DESKTOP_USERNAME = var.desktop_username
      GATEWAY_USERNAME = var.gateway_username
    })
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/init-scripts/25-darkstat.sh")
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/30-lubuntu-desktop.sh", {
      DESKTOP_USERNAME = var.desktop_username
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/32-lxqt-look-and-feel.sh", {
      DESKTOP_USERNAME = var.desktop_username
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/35-desktop-sharing.sh", {
      DESKTOP_USERNAME = var.desktop_username
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/40-pulseaudio-server.sh", {
      DESKTOP_USERNAME = var.desktop_username
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/45-mumble-client.sh", {
      SSL_DOMAIN       = var.gateway_dns_hostname
      MURMUR_PORT      = var.murmur_config.port
      MURMUR_PASSWORD  = var.murmur_config.password
      DESKTOP_USERNAME = var.desktop_username
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/50-trojita-mail.sh", {
      EMAIL_ADDRESS    = var.email_config.address
      IMAP_PASSWORD    = var.email_config.password
      DESKTOP_USERNAME = var.desktop_username
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/60-prevent-swapping.sh", {
      DESKTOP_USERNAME = var.desktop_username
    })
  }
}

