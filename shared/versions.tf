terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.14"
    }
  }
}

provider "aws" {
  profile = var.PROFILE
  region  = var.REGION
}

