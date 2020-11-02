resource "random_string" "imap_password" {
  length  = 16
  special = false // may lead to quoting issues otherwise
  keepers = {
    # Generate a new password each time we change the web address
    user_facing_web_address = local.url.full_hostname
  }
}

locals {
  email_config = {
    address   = "mail@${local.url.full_hostname}"
    password  = random_string.imap_password.result
    imap_port = 143
    smtp_port = 25
  }
}