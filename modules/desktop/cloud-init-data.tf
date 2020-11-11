# https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config

data "template_cloudinit_config" "desktop_config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-boothook"
    filename = "01-private-key-etc.sh"
    content = templatefile("${path.module}/init-scripts/01-private-key-etc.sh", {
      VM_PRIVATE_KEY = var.vm_mutual_keypair.private_key_pem
      VM_PUBLIC_KEY = var.vm_mutual_keypair.public_key_openssh
      DESKTOP_USERNAME = var.desktop_username
    })
  }
//  part {
//    content_type = "text/cloud-boothook"
//    filename = "02-disable-upgrades.sh"
//    content      = file("${path.module}/init-scripts/02-disable-upgrades.sh")
//  }
//  part {
//    content_type = "text/cloud-boothook"
//    filename = "03-sshd-config.sh"
//    content = file("${path.module}/init-scripts/03-sshd-config.sh")
//  }
//  part {
//    content_type = "text/cloud-config"
//    filename = "10-cloud-config.yaml"
//    content = templatefile("${path.module}/init-scripts/10-cloud-config.yaml", {
//      SSL_DOMAIN       = var.url.full_hostname
//      DESKTOP_TIMEZONE = var.location_info.timezone_name
//      DESKTOP_LOCALE   = var.location_info.locale_settings
//      DESKTOP_USERNAME = var.desktop_username
//      GATEWAY_USERNAME = var.gateway_username
//    })
//  }
//  part {
//    content_type = "text/x-shellscript"
//    filename = "11-sudoers.sh"
//    content      = templatefile("${path.module}/init-scripts/11-sudoers.sh", {
//      DESKTOP_USERNAME = var.desktop_username
//    })
//  }
//  part {
//    content_type = "text/x-shellscript"
//    filename = "15-install-packages.sh"
//    content = file("${path.module}/init-scripts/15-install-packages.sh")
//  }
//  part {
//    content_type = "text/x-shellscript"
//    filename = "20-ssh-tunnel.sh"
//    content = templatefile("${path.module}/init-scripts/20-ssh-tunnel.sh", {
//      SSL_DOMAIN        = var.url.full_hostname
//      MURMUR_PORT       = var.murmur_config.port
//      DESKTOP_USERNAME = var.desktop_username
//      GATEWAY_USERNAME = var.gateway_username
//    })
//  }
//  part {
//    content_type = "text/x-shellscript"
//    filename = "25-darkstat.sh"
//    content = file("${path.module}/init-scripts/25-darkstat.sh")
//  }
//  part {
//    content_type = "text/x-shellscript"
//    content = templatefile("${path.module}/init-scripts/30-mumble-client.sh", {
//      SSL_DOMAIN        = var.url.full_hostname
//      MURMUR_PORT       = var.murmur_config.port
//      MURMUR_PASSWORD   = var.murmur_config.password
//      DESKTOP_USERNAME = var.desktop_username
//    })
//  }
//  part {
//    content_type = "text/x-shellscript"
//    content = templatefile("${path.module}/init-scripts/40-trojita-mail.sh", {
//      SUB_DOMAIN_PREFIX = var.url.subdomain_label
//      EMAIL_ADDRESS     = var.email_config.address
//      IMAP_PASSWORD     = var.email_config.password
//      DESKTOP_USERNAME = var.desktop_username
//    })
//  }
}

locals {
  encoded_config = data.template_cloudinit_config.desktop_config.rendered
}
