locals {
  guacamole_home = "/var/tmp/guacamole"
  certbot_subfolder = "./letsencrypt/certbot"
}

resource "oci_core_instance" "gateway" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.client_workspace.id
  display_name        = "gateway"
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id        = oci_core_subnet.gateway_subnet.id
    display_name     = "eth0"
    assign_public_ip = true
    hostname_label   = "gateway"
  }

  source_details {
    source_type = "image"
    source_id   = var.images[var.region]
  }

  metadata = {
    ssh_authorized_keys = var.vm_public_key
    user_data = templatefile("cloud-init/gateway-userdata.tpl", {
      SSL_DOMAIN = local.domain
      SUB_DOMAIN_PREFIX = var.target_subdomain
      REGISTERED_DOMAIN = var.dns_zone_name
      EMAIL_ADDRESS = local.email_address
      IMAP_HOST = local.domain
      IMAP_PASSWORD = var.imap_password
      MURMUR_PORT = var.murmur_port
      MURMUR_PASSWORD = var.murmur_password
      GUACAMOLE_HOME = local.guacamole_home
      CERTBOT_FOLDER = local.certbot_subfolder
      STAGING_MODE = 0 # Set to 1 if you're testing your setup to avoid hitting request limits
    })
  }

  agent_config {
    is_management_disabled = true
    is_monitoring_disabled = true
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    port        = 22
    user        = "ubuntu"
    private_key = var.vm_private_key
  }

  provisioner "file" {
      content = var.vm_private_key
      destination = "/var/tmp/ssh/vm_key"
  }

  provisioner "remote-exec" {
    scripts = [
      "${local.script_dir}/common/update.sh",
      "${local.script_dir}/common/sshd.sh",
      "${local.script_dir}/common/networking.sh",
      "${local.script_dir}/common/sudoers.sh",
      "${local.script_dir}/common/docker-backend.sh"
    ]
  }

}

output "gateway" {
  value = oci_core_instance.gateway.public_ip
}

