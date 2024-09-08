// https://registry.terraform.io/providers/hashicorp/aws/latest/docs

provider "aws" {
  region     = var.hub_aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  alias  = "hub"
}

provider "aws" {
  region     = var.sat1_aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  alias  = "sat1"
}

variable "hub_aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "Seems to determines the region of all created resources."
  validation {
    condition = contains([
      "ca-west-1",      // Calgary
      // "ca-central-1",   // Central Canada
      // "sa-east-1"       // São Paulo
      // "eu-west-1",      // Ireland
      // "eu-south-2",     // Spain
      // "eu-west-2",      // London  
      // "eu-west-3",      // Paris
      // "eu-central-2",   // Zurich
      "eu-central-1",   // Frankfurt
      // "eu-south-1",     // Milan
      // "eu-north-1",     // Stockholm
      // "af-south-1",     // Cape Town
      // "il-central-1",   // Tel Aviv
      // "me-south-1",     // Bahrain
      // "me-central-1",   // UAE
      // "ap-south-1",     // Mumbai
      // "ap-south-2",     // Hyderabad
      // "ap-southeast-5", // Malaysia
      // "ap-southeast-1", // Singapore
      // "ap-southeast-3", // Jakarta
      // "ap-east-1",      // Hong Kong
      // "ap-northeast-2", // Seoul
      // "ap-northeast-3", // Osaka
      "ap-northeast-1", // Tokyo
      // "ap-southeast-4", // Melbourne
      // "ap-southeast-2", // Sydney
    ], var.hub_aws_region)
    error_message = "aws_region is not in the list of valid EC2 regions."
  }
}

variable "sat1_aws_region" {
  type        = string
  default     = "ca-west-1"
  description = "Seems to determines the region of all created resources."
  validation {
    condition = contains([
      "ca-west-1",      // Calgary
      // "ca-central-1",   // Central Canada
      // "sa-east-1"       // São Paulo
      // "eu-west-1",      // Ireland
      // "eu-south-2",     // Spain
      // "eu-west-2",      // London  
      // "eu-west-3",      // Paris
      // "eu-central-2",   // Zurich
      "eu-central-1",   // Frankfurt
      // "eu-south-1",     // Milan
      // "eu-north-1",     // Stockholm
      // "af-south-1",     // Cape Town
      // "il-central-1",   // Tel Aviv
      // "me-south-1",     // Bahrain
      // "me-central-1",   // UAE
      // "ap-south-1",     // Mumbai
      // "ap-south-2",     // Hyderabad
      // "ap-southeast-5", // Malaysia
      // "ap-southeast-1", // Singapore
      // "ap-southeast-3", // Jakarta
      // "ap-east-1",      // Hong Kong
      // "ap-northeast-2", // Seoul
      // "ap-northeast-3", // Osaka
      "ap-northeast-1", // Tokyo
      // "ap-southeast-4", // Melbourne
      // "ap-southeast-2", // Sydney
    ], var.sat1_aws_region)
    error_message = "aws_region is not in the list of valid EC2 regions."
  }
}

variable "aws_access_key" {
  type        = string
  description = "Generate here: https://console.aws.amazon.com/iam/home?#/security_credentials"
}

variable "aws_secret_key" {
  type        = string
  description = "Generate here: https://console.aws.amazon.com/iam/home?#/security_credentials"
}
