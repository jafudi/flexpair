// https://registry.terraform.io/providers/hashicorp/aws/latest/docs

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "Seems to determines the region of all created resources."
  validation {
    condition = contains([
      "af-south-1",     // Cape Town (Opt-in Required)
      "ap-east-1",      // Hong Kong (Opt-in Required)
      "ap-northeast-1", // Tokyo
      "ap-northeast-2", // Seoul
      "ap-northeast-3", // Osaka
      "ap-south-1",     // Mumbai
      "ap-southeast-1", // Singapore
      "ap-southeast-2", // Sydney
      "ca-central-1",   // Central Canada
      "eu-central-1",   // Frankfurt
      "eu-north-1",     // Stockholm
      "eu-south-1",     // Milan (Opt-in Required)
      "eu-west-1",      // Ireland
      "eu-west-2",      // London
      "eu-west-3",      // Paris
      "me-south-1",     // Bahrain (Opt-in Required)
      "sa-east-1",      // São Paulo
      "us-east-1",      // North Virginia
      "us-east-2",      // Ohio
      "us-west-1",      // Northern California
      "us-west-2",      // Oregon
    ], var.aws_region)
    error_message = "Undefined Amazon EC2 region specified."
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
