variable "timezone" {}

variable "locale" {}

# https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config

data "cloudinit_config" "desktop_config" {
  gzip = false
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("cloud-init-config/desktop-templates/10-cloud-config.yaml", {
      SSL_DOMAIN = local.domain
      DESKTOP_TIMEZONE = var.timezone
      DESKTOP_LOCALE = var.locale
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/desktop-templates/20-shell-script.sh", {
      SSL_DOMAIN = local.domain
      SUB_DOMAIN_PREFIX = local.subdomain
      EMAIL_ADDRESS = local.email_address
      IMAP_HOST = local.domain
      IMAP_PASSWORD = local.imap_password
      MURMUR_PORT = var.murmur_port
      MURMUR_PASSWORD = local.murmur_password
    })
  }
}

data "cloudinit_config" "gateway_config" {
  gzip = false
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("cloud-init-config/gateway-templates/10-cloud-config.yaml", {
      GATEWAY_TIMEZONE = var.timezone
      GATEWAY_LOCALE = var.locale
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/gateway-templates/20-shell-script.sh", {
      SSL_DOMAIN = local.domain
      EMAIL_ADDRESS = local.email_address
      GUACAMOLE_HOME = local.guacamole_home
      CERTBOT_FOLDER = local.certbot_subfolder
      STAGING_MODE = 0 # Set to 1 if you're testing your setup to avoid hitting request limits
    })
  }
}
