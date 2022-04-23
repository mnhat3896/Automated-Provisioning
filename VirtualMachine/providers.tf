# loads variables in the following order:
# env vars -> terraform.tfvars -> *.auto.tfvars -> -var and -var-file

terraform {
  required_version = ">=0.14"
  # backend "azurerm" {
  #   resource_group_name  = "terraform_tfstate"
  #   storage_account_name = "sademoazuretfstate"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate" 
  #   access_key           = "" # Will be puted in when init
  # }
  backend "local" {
    
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.97.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~>3.1.2"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  # credentials = var.key_file
  subscription_id = var.subscription_id
}

provider "random" {
  # Configuration options
}