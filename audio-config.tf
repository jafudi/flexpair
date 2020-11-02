resource "random_string" "murmur_password" {
  length  = 16
  special = false // may lead to quoting issues otherwise
  keepers = {
    # Generate a new password each time we change the web address
    user_facing_web_address = local.url.full_hostname
  }
}

locals {
  murmur_config = {
    port     = 64738
    password = random_string.murmur_password.result
  }
}