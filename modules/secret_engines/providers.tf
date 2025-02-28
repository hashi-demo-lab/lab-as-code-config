terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
  }
}