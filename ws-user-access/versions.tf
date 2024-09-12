terraform {
  required_providers {
    guacamole = {
      source  = "techBeck03/guacamole"
      version = "1.4.1" // parameterize together with Guacamole version
    }
  }
  required_version = "~> 1.5.0"
}
