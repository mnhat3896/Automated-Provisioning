resource "tls_private_key" "key_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

data "azurerm_resource_group" "rg_systemtest" {
  name = "rg-systemtest"
}

resource "azurerm_resource_group" "rg_systemtest" {
  name     = "rg_systemtest"
  location = ""
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = data.azurerm_resource_group.rg_systemtest.location
  resource_group_name = data.azurerm_resource_group.rg_systemtest.name
  dns_prefix          = var.dns_prefix
  tags = var.tags

  kubernetes_version  = var.k8s_version
  node_resource_group = var.resource_group_name
  depends_on              = [azurerm_virtual_network.vnet]
  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = "sysadmin"

    ssh_key {
      key_data = tls_private_key.key_ssh.public_key_openssh
    }
  }

  default_node_pool {
    name                = "agentpool"
    node_count          = var.k8s_node_count
    vm_size             = var.k8s_vm_size
    #enable_node_public_ip = false
    os_disk_size_gb     = "256"
    type                = var.k8s_node_pool_type
    vnet_subnet_id      = azurerm_subnet.subnet.id
    enable_auto_scaling = var.k8s_node_pool_enable_auto_scaling
  }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin    = "kubenet"
    # Standard is required because using VirtualMachineScaleSets
    load_balancer_sku = "Standard"
    # load_balancer_profile {
    #   outbound_ip_address_ids = [azurerm_public_ip.public_ip.id]
    # }
    }

  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }

  timeouts {
    create = "3h"
    delete = "3h"
  }
}


resource "azurerm_virtual_network" "vnet" {
  name                = "aks-vnet"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg_systemtest.name
  address_space       = ["10.250.0.0/16"]

  # subnet = []
  tags = var.tags

  timeouts {
    create = "3h"
    delete = "3h"
  }
}


resource "azurerm_subnet" "subnet" {
  name                 = "subnet-aks"
  resource_group_name  = data.azurerm_resource_group.rg_systemtest.name
  virtual_network_name = azurerm_virtual_network.vnet.name 
  address_prefixes     = ["10.250.1.0/24"]
  depends_on           = [azurerm_virtual_network.vnet]
}


# resource "azurerm_public_ip" "public_ip" {
#   name                = "public-ip-aks"
#   resource_group_name = data.azurerm_resource_group.rg_systemtest.name
#   location            = data.azurerm_resource_group.rg_systemtest.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   idle_timeout_in_minutes = "30"
#   tags                = var.tags
# }
