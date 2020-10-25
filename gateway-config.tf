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
    content = templatefile("cloud-init-config/gateway-templates/02-disable-upgrades.sh", {
      VM_PRIVATE_KEY = tls_private_key.vm_mutual_key.private_key_pem
    })
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
    content = templatefile("cloud-init-config/gateway-templates/20-shell-script.sh", {
      DOCKER_COMPOSE_RELEASE = local.docker_compose_release
      DOCKER_COMPOSE_FOLDER  = local.docker_compose_folder
    })
  }
}
