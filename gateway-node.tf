variable "gateway_shape" {}

locals {
  docker_compose_folder = "/var/tmp/docker-compose"
  certbot_repo          = "https://raw.githubusercontent.com/certbot/certbot/master"
}

resource "oci_core_instance" "gateway" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.one_per_subdomain.id
  display_name        = "gateway"
  shape               = var.gateway_shape

  # Continue only after certificate was successfully issued
  depends_on = [
    acme_certificate.letsencrypt_certificate
  ]

  create_vnic_details {
    subnet_id        = oci_core_subnet.gateway_subnet.id
    display_name     = "eth0"
    assign_public_ip = true
    hostname_label   = "gateway"
  }

  source_details {
    source_type = "image" # Ubuntu-20.04-Minimal
    source_id   = data.oci_core_images.ubuntu-20-04-minimal.images.0.id
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.vm_mutual_key.public_key_openssh
    user_data           = data.cloudinit_config.gateway_config.rendered
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
    private_key = tls_private_key.vm_mutual_key.private_key_pem
  }

  provisioner "remote-exec" {
    scripts = [
      "cloud-init-config/gateway-templates/01-disable-upgrades.sh",
      "cloud-init-config/gateway-templates/02-sshd.sh",
      "cloud-init-config/gateway-templates/03-networking.sh",
      "cloud-init-config/gateway-templates/04-sudoers.sh",
      "cloud-init-config/gateway-templates/05-message-of-the-day.sh"
    ]
  }

  # This file contains important security parameters for NGINX.
  provisioner "local-exec" {
    working_dir = "docker-compose/nginx/conf.d"
    command     = "curl -s ${local.certbot_repo}/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf | tee options-ssl-nginx.conf > /dev/null"
  }

  # Diffie-Hellman parameters for https://en.wikipedia.org/wiki/Forward_secrecy
  provisioner "local-exec" {
    working_dir = "docker-compose/letsencrypt"
    command     = "curl -s ${local.certbot_repo}/certbot/certbot/ssl-dhparams.pem | tee ssl-dhparams.pem > /dev/null"
  }

  provisioner "remote-exec" {
    inline = ["mkdir -p ${local.docker_compose_folder}"]
  }
  provisioner "file" {
    source      = "docker-compose/"
    destination = local.docker_compose_folder
  }

  provisioner "file" {
    content = templatefile("docker-compose/murmur_config/murmur.tpl.ini", {
      SSL_DOMAIN      = local.domain
      MURMUR_PORT     = var.murmur_port
      MURMUR_PASSWORD = local.murmur_password
    })
    destination = "${local.docker_compose_folder}/murmur_config/murmur.ini"
  }

  provisioner "file" {
    content = templatefile("docker-compose/docker-compose.tpl.yml", {
      SSL_DOMAIN    = local.domain
      EMAIL_ADDRESS = local.email_address
      IMAP_HOST     = local.domain
      IMAP_PASSWORD = local.imap_password
      MURMUR_PORT   = var.murmur_port
    })
    destination = "${local.docker_compose_folder}/docker-compose.yml"
  }

  provisioner "file" {
    content     = acme_certificate.letsencrypt_certificate.private_key_pem
    destination = join("/", [local.docker_compose_folder, "letsencrypt", "privkey.pem"])
  }

  provisioner "file" {
    content     = local.acme_cert_fullchain
    destination = join("/", [local.docker_compose_folder, "letsencrypt", "fullchain.pem"])
  }

  provisioner "file" {
    source      = "upload-directory/"
    destination = "/home/ubuntu/uploads"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo touch /etc/.terraform-complete",
      "sudo cloud-init clean --logs",
      "sudo shutdown -r +1"
    ]
  }

}

output "gateway" {
  value = "${oci_core_instance.gateway.public_ip}, domain = ${local.domain}/?password=${local.murmur_password}"
}

