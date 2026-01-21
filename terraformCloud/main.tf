
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "myvcpDemo"

    workspaces {
      name = "AzTerraformResGrp"
    }
  }
}

provider "azurerm" {
  features {}
}


# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "tfcloud-resources"
  location = "East US"
}
