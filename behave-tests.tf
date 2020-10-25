resource "null_resource" "health_check" {

  for_each = toset([
    "/",
    "/guacamole/",
    "/gateway-traffic/",
    "/desktop-traffic/"
  ])

  triggers = {
    on_every_apply = timestamp()
  }

  depends_on = [
    oci_core_instance.gateway,
    time_sleep.gateway_unnecessary_reboot,
    time_sleep.dns_propagation,
    oci_core_instance.desktop,
    time_sleep.desktop_unnecessary_reboot
  ]

  provisioner "local-exec" {
    environment = {
      URL = "https://${local.domain}${each.key}"
    }
    interpreter = ["/bin/bash", "-c"]
    command     = "wget --spider $URL; [[ $? == '0' ]] || exit 1;"
  }
}