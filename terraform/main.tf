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
  #ARM_CLIENT_ID = ${{ secrets.AZURE_AD_CLIENT_ID }}
  #ARM_CLIENT_SECRET = ${{ secrets.AZURE_AD_CLIENT_SECRET }}
  subscription_id = ${{ secrets.AZURE_SUBSCRIPTION_ID }}
  tenant_id = ${{ secrets.AZURE_AD_TENANT_ID }}
}


# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}
