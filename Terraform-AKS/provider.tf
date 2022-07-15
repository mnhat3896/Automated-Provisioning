# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.14.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "terraform_tfstate"
  #   storage_account_name = "sanhatletfstate"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate" 
  #   access_key           = "" # Will be puted in when init
  # }
}

provider "azurerm" {
  # features {}
}