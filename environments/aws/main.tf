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

module "amazon_hub_infrastructure" {
  deployment_tags = local.deployment_tags
  source          = "app.terraform.io/Flexpair/commons/aws"
  version         = "4.0.0"
  providers = {
    aws = aws.hub
  }
}

module "amazon_sat1_infrastructure" {
  count = local.cross_region ? 1 : 0
  deployment_tags = local.deployment_tags
  source          = "app.terraform.io/Flexpair/commons/aws"
  version         = "4.0.0"
  providers = {
    aws = aws.sat1
  }
}

locals {
  cross_region = var.hub_aws_region != var.sat1_aws_region
  gateway_creation_context = module.amazon_hub_infrastructure.vm_creation_context
  gateway_additional_info  = module.amazon_hub_infrastructure.additional_metadata
  desktop_creation_context = local.cross_region ? module.amazon_sat1_infrastructure[0].vm_creation_context : module.amazon_hub_infrastructure.vm_creation_context
  desktop_additional_info  = local.cross_region ? module.amazon_sat1_infrastructure[0].additional_metadata : module.amazon_hub_infrastructure.additional_metadata
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
  admin_public_keys      = var.admin_public_keys
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
  source                 = "app.terraform.io/Flexpair/hubconfig/cloudinit"
  version                = "1.0.0"
  guacamole_version      = "1.3.0"
}

# TODO: Fully parameterize VNC crendetials
module "desktop_installer" {
  admin_public_keys    = var.admin_public_keys
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
  vnc_port             = module.credentials_generator.vnc_credentials.vnc_port
  source               = "app.terraform.io/Flexpair/satellite/cloudinit"
  version              = "1.9.0"
}

locals {
  unzipped_desktop_bytes = length(module.desktop_installer.unzipped_config)
  encoded_desktop_config = module.desktop_installer.encoded_config
  unzipped_gateway_bytes = length(module.gateway_installer.unzipped_config)
  encoded_gateway_config = module.gateway_installer.encoded_config
}

resource "local_file" "desktop_meta_data" {
  content  = "instance-id: iid-local01\nlocal-hostname: cloudimg"
  filename = "${path.root}/../../uploads/desktop-config/meta-data"
}

resource "local_sensitive_file" "desktop_user_data" {
  content  = module.desktop_installer.unzipped_config
  filename = "${path.root}/../../uploads/desktop-config/user-data"
}

resource "local_file" "gen_iso_script" {
  content         = "sudo apt-get update\nsudo apt-get -y install genisoimage\ngenisoimage -output config.iso -volid cidata -joliet -rock user-data meta-data"
  filename        = "${path.root}/../../uploads/desktop-config/gen-config-iso.sh"
  file_permission = "0777"
}

module "gateway_machine" {
  depends_on = [
    local_file.desktop_meta_data,
    local_sensitive_file.desktop_user_data,
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
  version = "4.0.0"
  // below variables are provider specific
  cloud_provider_context = local.gateway_creation_context
  providers = {
    aws = aws.hub
  }
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
  version = "4.0.0"
  // below variables are provider specific
  cloud_provider_context = local.desktop_creation_context
  providers = {
    aws = aws.sat1
  }
}

check "health_check_1" {
  data "http" "home_page" {
    url = "https://${local.full_hostname}/"
  }

  assert {
    condition = data.http.home_page.status_code == 200
    error_message = "${data.http.home_page.url} returned an unhealthy status code"
  }
}

check "health_check_2" {
  data "http" "guacamole_page" {
    url = "https://${local.full_hostname}/guacamole/"
  }

  assert {
    condition = data.http.guacamole_page.status_code == 200
    error_message = "${data.http.guacamole_page.url} returned an unhealthy status code"
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
  terraform_version = "~> 1.9.0"
  organization      = local.organization
  description       = "Identity and access management"
  working_directory = "ws-user-access"
  auto_apply        = true
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
