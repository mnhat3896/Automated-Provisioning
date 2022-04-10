resource "azurerm_resource_group" "rg" {
  name     = "resources-${local.common_labels.environment}"
  location = var.location

}
#####################
###### Network ######
#####################
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.common_labels.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space

  tags = local.common_labels
}

resource "azurerm_subnet" "subnets" {
  for_each = var.vnet_subnets

  # count = length(var.vnet_subnets) > 0 ? length(var.vnet_subnets) : 0
  # name                 = "${var.vnet_subnets[count.index].subnet_name}-${local.common_labels.environment}"
  name                 = "${each.value.subnet_name}-${local.common_labels.environment}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefix

}

resource "azurerm_network_security_group" "nsg1" {
  name                = "security-group-${local.common_labels.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "inbound_tcp_8080"
    priority                   = 100
    description                = "Allow traffic to instance via port 8080"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "inbound_ssh"
    priority                   = 101
    description                = "Allow SSH to instance"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.common_labels
}

resource "azurerm_route_table" "route_table" {
  count = length(var.vnet_subnets)

  name                          = "route-table-subnet${count.index + 1}-${local.common_labels.environment}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  dynamic "route" {
    for_each = {
      for k, v in var.vnet_subnets : k => v
      # avoid creating route for subnet it self
      if v.subnet_name != var.vnet_subnets[count.index].subnet_name
    }
    content {
      name           = "to-${route.value.subnet_name}"
      address_prefix = route.value.address_prefix[0]
      next_hop_type  = "VnetLocal"
    }
  }

  tags = local.common_labels
}

resource "azurerm_subnet_route_table_association" "subnet_route_table_association" {
  count = length(var.vnet_subnets)

  subnet_id      = azurerm_subnet.subnets[count.index].id
  route_table_id = azurerm_route_table.route_table[count.index].id
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association1" {
  count = length(var.vnet_subnets)
  # for_each = var.vnet_subnets

  subnet_id                 = azurerm_subnet.subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "random_uuid" "uuid" {
}

##########################
###### LoadBalancer ######
##########################

# module "instancesLB" {
#   source              = "Azure/loadbalancer/azurerm"
#   version             = "3.4.0"
#   resource_group_name = azurerm_resource_group.rg.name
#   name                = "lb-instances-${local.common_labels.environment}"
#   pip_name            = "publicIP-lb-${local.common_labels.environment}"
#   allocation_method   = "Dynamic"
#   frontend_name       = "frontend-publicIP"

#   # Protocols to be used for remote vm access. [protocol, backend_port]  
#   remote_port = {
#     ssh = ["Tcp", "22"]
#   }

#   # Protocols to be used for lb rules. Format as [frontend_port, protocol, backend_port]
#   lb_port = {
#     http = ["80", "Tcp", "80"]
#   }

#   lb_probe = {
#     http = ["Tcp", "80", ""]
#   }

#   tags = local.common_labels

#   depends_on = [
#     azurerm_resource_group.rg
#   ]
# }
