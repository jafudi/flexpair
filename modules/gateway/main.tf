locals {
  module_name = basename(abspath(path.module))
  hostname = replace(lower(local.module_name), " ", "")
  display_name = title(local.module_name)
}