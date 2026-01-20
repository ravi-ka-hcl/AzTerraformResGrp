terraform {
  backend "artifactory" {
    hostname     = "https://trialpf4dwg.jfrog.io/artifactory"
    organization = "tempstroage-generic-local" # Repository name
    # The workspace name will be used as the prefix for the state file in Artifactory
    # For example, a workspace named "prod" will store the state at <repo_key>/prod/terraform.tfstate
    prefix       = "dev" 
  }

  terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
    }
  }
}

provider "azurerm" {
  features {}
}


# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "jf-resources"
  location = "East US"
}
