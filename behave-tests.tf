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
      WAIT = 120
      URL  = "https://${local.subdomain}.${var.registered_domain}"
      CMD  = "curl --write-out '%%{http_code}' --silent --head --output /dev/null"
    }
    command = "sleep $WAIT; RET=$($CMD $URL); [[ $RET -eq 200 ]] || exit 1;"
  }
}