terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

terraform {
  backend "azurerm" {
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "tls_private_key" "key_ssh" {
  algorithm   = "RSA"
  rsa_bits    = 4096
}

resource "azurerm_network_security_group" "nsg" {
  name                = "rsg_bravo_monitoring"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = var.tag
}

resource "azurerm_network_security_rule" "nsg_rule22" {
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
  name                       = "allow_22"
  priority                   = 300
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  # source_address_prefixes    = (Optional) List of source address prefixes
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "nsg_rule443" {
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
  name                       = "allow_443"
  priority                   = 301
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  # source_address_prefixes    = (Optional) List of source address prefixes
  destination_address_prefix = "*"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet_bravo_monitoring"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_address_space]
  tags = var.tag
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.vnet_subnet_prefixes]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "public_ip_bravo_monitoring"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  tags = var.tag
}

resource "azurerm_network_interface" "nic" {
  name                = "nic_bravo_monitoring"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "ip_internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
  tags = var.tag
}

resource "azurerm_linux_virtual_machine" "vm_linux" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  depends_on          = [tls_private_key.key_ssh, azurerm_network_interface.nic]
  size                = var.vm_size
  admin_username      = var.vm_authen_username
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = var.vm_authen_username
    public_key = tls_private_key.key_ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_os_disk_type
    disk_size_gb         = var.vm_disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = var.vm_offer
    sku       = var.vm_image_sku
    version   = "latest"
  }
  tags = var.tag
}
