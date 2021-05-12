# resource "azurerm_storage_account" "sa" {
#   name                     = var.storage_account_name
#   resource_group_name      = var.resource_group_name
#   location                 = var.location
#   account_tier             = "Standard"
#   account_replication_type = "RAGRS"
#   account_kind             = "StorageV2"
#   access_tier              = "Hot"
#   # have to set true for type containers is container
#   allow_blob_public_access = true
#   depends_on               = [azurerm_kubernetes_cluster.k8s]
#   tags                     = var.tags
# }

resource "azurerm_storage_container" "sa_container1" {
  name                  = var.storage_account_container_name1
  storage_account_name  = var.storage_account_name
  container_access_type = "container"
}

resource "azurerm_storage_container" "sa_container2" {
  name                  = var.storage_account_container_name2
  storage_account_name  = var.storage_account_name
  container_access_type = "container"
}
