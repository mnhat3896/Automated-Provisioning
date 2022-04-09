# loads variables in the following order:
# env vars -> terraform.tfvars -> *.auto.tfvars -> -var and -var-file

terraform {
  required_version = ">=0.14"

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