terraform {
  required_providers {
    guacamole = {
      source  = "techBeck03/guacamole"
      version = "1.2.10" // parameterize together with Guacamole version
    }
  }
  required_version = "~> 1.9.0"
}
