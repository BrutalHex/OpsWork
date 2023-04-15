terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "4.58.0"
    }

  }
  required_version = ">=1.3.6"
  backend "s3" {

    bucket = "terraform-state-my-app-systems"
    key    = "kubereks/state.tfstate"
    region = "eu-central-1"

  }
}


provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

