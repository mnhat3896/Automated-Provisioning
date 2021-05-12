data "local_file" "start_stop_vmss_file" {
  filename = "./stop-start-VMSS.ps1"
}


# data "azurerm_resource_group" "rg_systemtest" {
#   name = "rg_systemtest"
# }
