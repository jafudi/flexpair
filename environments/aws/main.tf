resource "random_pet" "subdomain" {
  length    = 2
  separator = "-"
}

locals {
  deployment_tags = {
    terraform_run_id = var.TFC_RUN_ID
    git_commit_hash  = var.TFC_CONFIGURATION_VERSION_GIT_COMMIT_SHA
  }

  org_list        = split("/", var.TFC_WORKSPACE_SLUG)
  organization    = local.org_list[0]
  workspace       = local.org_list[1]
  valid_subdomain = random_pet.subdomain.id # in PROD: lower(replace(local.workspace, "/[_\\W]/", "-"))
  full_hostname   = "${local.valid_subdomain}.${var.registered_domain}"


}

module "amazon_infrastructure" {
  deployment_tags = local.deployment_tags
  source          = "app.terraform.io/Flexpair/commons/aws"
  version         = "1.0.1"
}

locals {
  gateway_creation_context = module.amazon_infrastructure.vm_creation_context
  gateway_additional_info  = module.amazon_infrastructure.additional_metadata
  desktop_creation_context = module.amazon_infrastructure.vm_creation_context
  desktop_additional_info  = module.amazon_infrastructure.additional_metadata
}

module "credentials_generator" {
  full_hostname         = local.full_hostname
  demo_hostname         = local.demo_hostname
  gateway_context_hash  = sha512(join("", values(local.gateway_creation_context)))
  desktop_context_hash  = sha512(join("", values(local.desktop_creation_context)))
  gateway_cloud_account = local.gateway_additional_info.cloud_account_name
  desktop_cloud_account = local.desktop_additional_info.cloud_account_name
  source                = "../../modules/terraform-tls-credentials"
  // below variables are provider specific
  dnsimple_account_token = var.dnsimple_account_token
}

# TODO: Fully parameterize VNC crendetials
# TODO: Fully parameterize Guacamole credentials
module "gateway_installer" {
  timezone_name          = var.timezone
  locale_name            = var.locale
  vm_mutual_keypair      = module.credentials_generator.vm_mutual_key
  gateway_username       = module.credentials_generator.gateway_username
  desktop_username       = module.credentials_generator.desktop_username
  ssl_certificate        = module.credentials_generator.letsencrypt_certificate
  murmur_config          = module.credentials_generator.murmur_credentials
  demo_hostname          = local.demo_hostname
  gateway_dns_hostname   = local.full_hostname
  email_config           = module.credentials_generator.email_config
  docker_compose_release = local.docker_compose_release
  mumbling_mole_version  = local.mumbling_mole_version
  first_vnc_port         = module.credentials_generator.vnc_credentials.vnc_port
  guacamole_admin        = module.credentials_generator.guacamole_credentials.guacamole_admin_username
  source                 = "app.terraform.io/Flexpair/station/cloudinit"
  version                = "1.6.6"
}

# TODO: Fully parameterize VNC crendetials
module "desktop_installer" {
  timezone_name        = var.timezone
  gitlab_runner_token  = var.gitlab_runner_token
  locale_name          = var.locale
  vm_mutual_keypair    = module.credentials_generator.vm_mutual_key
  gateway_username     = module.credentials_generator.gateway_username
  desktop_username     = module.credentials_generator.desktop_username
  murmur_config        = module.credentials_generator.murmur_credentials
  browser_url          = module.credentials_generator.browser_url
  gateway_dns_hostname = local.full_hostname
  email_config         = module.credentials_generator.email_config
  gateway_vnc_port     = module.credentials_generator.vnc_credentials.vnc_port
  source               = "app.terraform.io/Flexpair/satellite/cloudinit"
  version              = "1.7.10"
}

locals {
  unzipped_desktop_bytes = length(module.desktop_installer.unzipped_config)
  encoded_desktop_config = module.desktop_installer.encoded_config
  unzipped_gateway_bytes = length(module.gateway_installer.unzipped_config)
  encoded_gateway_config = module.gateway_installer.encoded_config
}

resource "local_file" "desktop_meta_data" {
  content  = "instance-id: iid-local01\nlocal-hostname: cloudimg"
  filename = "${path.root}/../uploads/desktop-config/meta-data"
}

resource "local_file" "desktop_user_data" {
  sensitive_content = module.desktop_installer.unzipped_config
  filename          = "${path.root}/../uploads/desktop-config/user-data"
}

resource "local_file" "gen_iso_script" {
  content         = "sudo apt-get update\nsudo apt-get -y install genisoimage\ngenisoimage -output config.iso -volid cidata -joliet -rock user-data meta-data"
  filename        = "${path.root}/../uploads/desktop-config/gen-config-iso.sh"
  file_permission = "0777"
}

module "gateway_machine" {
  depends_on = [
    local_file.desktop_meta_data,
    local_file.desktop_user_data,
    local_file.gen_iso_script
  ]
  deployment_tags   = local.deployment_tags
  gateway_username  = module.credentials_generator.gateway_username
  encoded_userdata  = local.encoded_gateway_config
  vm_mutual_keypair = module.credentials_generator.vm_mutual_key
  open_tcp_ports = {
    ssh    = 22
    https  = 443
    http   = 80
    mumble = module.credentials_generator.murmur_credentials.port
    smtp   = module.credentials_generator.email_config.smtp_port
    sip    = 5060
  }
  source  = "app.terraform.io/Flexpair/gateway/aws"
  version = "1.1.1"
  // below variables are provider specific
  cloud_provider_context = local.gateway_creation_context
}

module "desktop_machine_1" {
  deployment_tags   = local.deployment_tags
  instance_shape    = "t2.small"
  desktop_username  = module.credentials_generator.desktop_username
  encoded_userdata  = local.encoded_desktop_config
  vm_mutual_keypair = module.credentials_generator.vm_mutual_key
  depends_on = [
    # Desktop without gateway would be of little use
    module.gateway_installer
  ]
  source  = "app.terraform.io/Flexpair/desktop/aws"
  version = "1.2.1"
  // below variables are provider specific
  cloud_provider_context = local.desktop_creation_context
}

resource "null_resource" "health_check" {

  for_each = toset([
    "/",
    "/guacamole/"
  ])

  triggers = {
    on_every_apply = timestamp()
  }

  depends_on = [
    module.gateway_machine,
    time_sleep.dns_propagation
  ]

  # Check HTTPS endpoint and first-level links availability
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "wget --tries=30 --spider --recursive --level 1 https://${local.full_hostname}${each.key};"
  }
}

provider "tfe" {
  hostname = "app.terraform.io"
  token    = var.tfc_api_token
}

resource "tfe_oauth_client" "github" {
  organization     = local.organization
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_personal_access_token
  service_provider = "github"
}

data "tfe_workspace" "main" {
  name         = local.workspace
  organization = local.organization
}
resource "tfe_workspace" "iam" {
  name              = "${local.workspace}-iam"
  organization      = local.organization
  description       = "Identity and access management"
  working_directory = "ws-user-access"
  vcs_repo {
    oauth_token_id = tfe_oauth_client.github.oauth_token_id
    identifier     = "jafudi/flexpair"
    branch         = data.tfe_workspace.main.vcs_repo[0].branch
  }
}
resource "tfe_run_trigger" "test" {
  workspace_id  = tfe_workspace.iam.id
  sourceable_id = data.tfe_workspace.main.id
}
resource "tfe_variable" "organization_name" {
  key          = "organization_name"
  value        = local.organization
  category     = "terraform"
  workspace_id = tfe_workspace.iam.id
  description  = ""
}
resource "tfe_variable" "parent_workspace_name" {
  key          = "parent_workspace_name"
  value        = local.workspace
  category     = "terraform"
  workspace_id = tfe_workspace.iam.id
  description  = ""
}
