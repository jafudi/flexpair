variable "timezone" {}

variable "locale" {}

# https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config

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
//  part {
//    content_type = "text/cloud-boothook"
//    content      = file("cloud-init-config/gateway-templates/03-sshd-config.sh")
//  }
//  part {
//    content_type = "text/cloud-boothook"
//    content      = file("cloud-init-config/gateway-templates/05-sudoers.sh")
//  }
  part {
    content_type = "text/cloud-config"
    content = templatefile("cloud-init-config/gateway-templates/10-cloud-config.yaml", {
      GATEWAY_TIMEZONE = var.timezone
      GATEWAY_LOCALE   = var.locale
    })
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/gateway-templates/11-networking.sh", {
      VNC_PORT = 5900
    })
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("cloud-init-config/gateway-templates/15-etc.sh")
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("cloud-init-config/gateway-templates/20-after-restart.sh", {
      DOCKER_COMPOSE_RELEASE = local.docker_compose_release
      DOCKER_COMPOSE_FOLDER  = local.docker_compose_folder
    })
  }
}

# The size of the config is limited to 16384 bytes on most platforms
output "gateway_config_size" {
  value = "${length(data.cloudinit_config.gateway_config.rendered)} bytes"
}