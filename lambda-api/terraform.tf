terraform {
  experiments = [module_variable_optional_attrs]

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.30.0"
    }
  }
}

provider "aws" {
  region = local.aws.region
  shared_credentials_file = local.aws.shared_credentials_file
}
