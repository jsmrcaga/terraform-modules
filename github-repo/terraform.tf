terraform {
  required_version = ">= 1.3.0"
  # From terraform v1.3 no need for experiment
  required_providers {
    github = {
      source = "integrations/github"
      version = "~> 4.0"
    }
  }
}

provider "github" {
  token = var.github.token
}
