variable "timezone" {}

variable "locale" {}

# https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config

data "cloudinit_config" "desktop_config" {
  gzip          = false
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("cloud-init-config/desktop-templates/10-cloud-config.yaml", {
      SSL_DOMAIN       = local.domain
      DESKTOP_TIMEZONE = var.timezone
      DESKTOP_LOCALE   = var.locale
      VM_PRIVATE_KEY   = indent(4,tls_private_key.vm_mutual_key.private_key_pem)
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/desktop-templates/20-shell-script.sh", {
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

data "cloudinit_config" "gateway_config" {
  gzip          = false
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("cloud-init-config/gateway-templates/10-cloud-config.yaml", {
      GATEWAY_TIMEZONE = var.timezone
      GATEWAY_LOCALE   = var.locale
      VM_PRIVATE_KEY   = indent(4,tls_private_key.vm_mutual_key.private_key_pem)
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/gateway-templates/20-shell-script.sh", {
      DOCKER_COMPOSE_RELEASE = local.docker_compose_release
      DOCKER_COMPOSE_FOLDER  = local.docker_compose_folder
    })
  }
}
