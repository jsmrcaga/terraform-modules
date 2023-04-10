terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "> 4.60.0"
    }
  }
}

provider "aws" {
  region = var.aws.region
  shared_credentials_files = [var.aws.shared_credentials_file]
}
