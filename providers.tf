#######################################################
# required providers
#######################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

#######################################################
# provider configuration
#######################################################
provider "aws" {
  region = var.region
}
