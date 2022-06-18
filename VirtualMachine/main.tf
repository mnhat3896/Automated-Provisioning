terraform {
  required_version = "~>1.1.7"
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
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  # credentials = var.key_file
  subscription_id = var.subscription_id
  # use when run with service principle
  # client_id       = ""
  # client_secret   = ""
  # tenant_id       = ""
}


resource "azurerm_resource_group" "rg" {
  name     = "resources-${local.common_labels.environment}"
  location = var.location

  tags = local.common_labels
}

module "virtual_machine" {
  source              = "./modules/compute"
  vm_instances        = var.vm_instances
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_ids          = [ for subnet in azurerm_subnet.subnets: subnet.id ]
  tags                = local.common_labels
}

