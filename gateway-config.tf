variable "timezone" {}

variable "locale" {}

# https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config

locals {
  dc_config_rendered = templatefile("cloud-init-config/gateway-templates/docker-compose.tpl.yml", {
    SSL_DOMAIN    = local.domain
    EMAIL_ADDRESS = local.email_address
    IMAP_HOST     = local.domain
    IMAP_PASSWORD = local.imap_password
    MURMUR_PORT   = var.murmur_port
  })
}

locals { # Folders to create on target system
  docker_compose_folder = "/var/tmp/docker-compose"
  murmur_config_folder  = "${local.docker_compose_folder}/murmur_config"
  nginx_config_folder   = "${local.docker_compose_folder}/nginx"
  letsencrypt_folder    = "${local.docker_compose_folder}/letsencrypt"
  guacamole_config      = "${local.docker_compose_folder}/guaca_config"
}

locals {
  certbot_repo_url = "https://raw.githubusercontent.com/certbot/certbot/master"
}

data "cloudinit_config" "gateway_config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-boothook"
    content = templatefile("cloud-init-config/gateway-templates/01-private-key-etc.sh", {
      VM_PRIVATE_KEY = tls_private_key.vm_mutual_key.private_key_pem
    })
  }
  part {
    content_type = "text/cloud-boothook"
    content      = file("cloud-init-config/gateway-templates/02-disable-upgrades.sh")
  }
  part {
    content_type = "text/cloud-boothook"
    content      = file("cloud-init-config/gateway-templates/03-sshd-config.sh")
  }
  part {
    content_type = "text/cloud-config"
    content = templatefile("cloud-init-config/gateway-templates/10-cloud-config.yaml", {
      GATEWAY_TIMEZONE = var.timezone
      GATEWAY_LOCALE   = var.locale
    })
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("cloud-init-config/gateway-templates/11-sudoers.sh")
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/gateway-templates/13-networking.sh", {
      VNC_PORT = 5900
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/gateway-templates/60-guacamole-config.sh", {
      GUACAMOLE_CONFIG = local.guacamole_config
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/gateway-templates/70-murmur-config.sh", {
      MURMUR_CONFIG   = local.murmur_config_folder
      SSL_DOMAIN      = local.domain
      MURMUR_PORT     = var.murmur_port
      MURMUR_PASSWORD = local.murmur_password
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/gateway-templates/80-nginx-config.sh", {
      NGINX_CONFIG = local.nginx_config_folder
      CERTBOT_REPO = local.certbot_repo_url
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/gateway-templates/90-letsencrypt-certs.sh", {
      CERT_FOLDER  = local.letsencrypt_folder
      PRIVATE_KEY  = acme_certificate.letsencrypt_certificate.private_key_pem
      CERTIFICATE  = acme_certificate.letsencrypt_certificate.certificate_pem
      ISSUER_CHAIN = acme_certificate.letsencrypt_certificate.issuer_pem
      CERTBOT_REPO = local.certbot_repo_url
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/gateway-templates/99-docker-compose.sh", {
      DOCKER_COMPOSE_REPO   = "https://github.com/docker/compose/releases/download/${local.docker_compose_release}"
      DOCKER_COMPOSE_FOLDER = local.docker_compose_folder
      DOCKER_COMPOSE_YAML   = local.dc_config_rendered
    })
  }

}

# The size of the config is limited to 16384 bytes on most platforms
output "gateway_user_data" {
  value = "${length(base64gzip(data.cloudinit_config.gateway_config.rendered))} bytes"
}
