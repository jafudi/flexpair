resource "null_resource" "health_check" {

  triggers = {
    on_every_apply = timestamp()
  }

  depends_on = [
    dns_a_record_set.gateway_hostname,
    oci_core_instance.gateway
  ]

  provisioner "local-exec" {
    environment = {
      WAIT_BEFORE = 120
      CHECK_IF_OK = "curl --write-out '%{http_code}' --silent --head --output /dev/null https://${local.subdomain}.${var.registered_domain}"
    }
    command = "sleep ${WAIT_BEFORE}; [ $(CHECK_IF_OK) -eq 200 ] || exit 1;"
  }
}