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