data "template_file" "docker_compose_config" {
  template = file("${path.module}/init-scripts/docker-compose.tpl.yml")
  vars = {
    SSL_DOMAIN    = var.url.full_hostname
    EMAIL_ADDRESS = var.email_config.address
    IMAP_HOST     = var.url.full_hostname
    IMAP_PASSWORD = var.email_config.password
    MURMUR_PORT   = var.murmur_config.port
  }
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

# https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config
data "template_cloudinit_config" "gateway_config" {
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
      GATEWAY_TIMEZONE = var.location_info.timezone_name
      GATEWAY_LOCALE   = var.location_info.locale_settings
      GATEWAY_USERNAME = var.gateway_username
      SSH_PUBLIC_KEY   = var.vm_mutual_keypair.public_key_openssh
    })
  }
  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/init-scripts/11-add-privkey.sh", {
      GATEWAY_USERNAME = var.gateway_username
      VM_PRIVATE_KEY = var.vm_mutual_keypair.private_key_pem
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/13-networking.sh", {
      VNC_PORT = 5900
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/60-guacamole-config.sh", {
      GUACAMOLE_CONFIG = local.guacamole_config
      GATEWAY_USERNAME = var.gateway_username
      DESKTOP_USERNAME = var.desktop_username
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/70-murmur-config.sh", {
      MURMUR_CONFIG   = local.murmur_config_folder
      SSL_DOMAIN      = var.url.full_hostname
      MURMUR_PORT     = var.murmur_config.port
      MURMUR_PASSWORD = var.murmur_config.password
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/80-nginx-config.sh", {
      NGINX_CONFIG = local.nginx_config_folder
      CERTBOT_REPO = local.certbot_repo_url
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/90-letsencrypt-certs.sh", {
      CERT_FOLDER  = local.letsencrypt_folder
      PRIVATE_KEY  = var.ssl_certificate.private_key_pem
      CERTIFICATE  = var.ssl_certificate.certificate_pem
      ISSUER_CHAIN = var.ssl_certificate.issuer_pem
      CERTBOT_REPO = local.certbot_repo_url
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/init-scripts/99-docker-compose.sh", {
      DOCKER_COMPOSE_REPO   = "https://github.com/docker/compose/releases/download/${var.docker_compose_release}"
      DOCKER_COMPOSE_FOLDER = local.docker_compose_folder
      DOCKER_COMPOSE_YAML   = data.template_file.docker_compose_config.rendered
      GATEWAY_USERNAME = var.gateway_username
    })
  }
}

locals {
  unzipped_config = data.template_cloudinit_config.gateway_config.rendered
}

