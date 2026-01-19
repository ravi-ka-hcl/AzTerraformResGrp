terraform {
  backend "remote" {
    hostname     = "<YOUR_JFROG_URL>"
    organization = "<YOUR_ARTIFactory_REPO_KEY>" # Repository name
    # The workspace name will be used as the prefix for the state file in Artifactory
    # For example, a workspace named "prod" will store the state at <repo_key>/prod/terraform.tfstate
    prefix       = "env/prod" 
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  # Authentication will be handled by environment variables in GitHub Actions
}
