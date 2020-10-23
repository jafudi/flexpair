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
      WAIT  = 1
      CHECK = "wget --spider --recursive"
      URL   = "https://${local.subdomain}.${var.registered_domain}"
    }
    interpreter = ["/bin/bash", "-c"]
    command     = "sleep $WAIT; $CHECK $URL; [[ $? == '0' ]] || exit 1;"
  }
}