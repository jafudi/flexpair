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
      CHECK_URL   = "https://${local.subdomain}.${var.registered_domain}"
      CHECK_CMD   = "curl --write-out '%%{http_code}' --silent --head --output /dev/null"
    }
    command = "sleep ${WAIT_BEFORE}; RET=$(${CHECK_CMD} ${CHECK_URL}); [ $RET -eq 200 ] || exit 1;"
  }
}