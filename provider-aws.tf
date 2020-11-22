// https://registry.terraform.io/providers/hashicorp/aws/latest/docs

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "aws_access_key" {
  type        = string
  description = "Generate here: https://console.aws.amazon.com/iam/home?#/security_credentials"
}

variable "aws_secret_key" {
  type        = string
  description = "Generate here: https://console.aws.amazon.com/iam/home?#/security_credentials"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}