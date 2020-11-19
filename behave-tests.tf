resource "null_resource" "health_check" {

  for_each = toset([
    "/",
    "/guacamole/",
    "/desktop-traffic/"
  ])

  triggers = {
    on_every_apply = timestamp()
  }

  depends_on = [
    module.gateway,
    time_sleep.dns_propagation,
    module.desktop_1
  ]

  # Check HTTPS endpoint and first-level links availability
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "wget --tries=30 --spider --recursive --level 1 https://${local.url.full_hostname}${each.key};"
  }
}