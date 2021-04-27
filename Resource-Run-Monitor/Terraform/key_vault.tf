data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "kv" {
  name                       = var.keyvault_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 30

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "list",
      "set",
      "get",
      "delete",
      "purge",
      "recover"
    ]
  }

  tags = var.tag
}

resource "azurerm_key_vault_secret" "kv_secret" {
  name         = var.keyvault_secret_name
  value        = tls_private_key.key_ssh.private_key_pem
  key_vault_id = azurerm_key_vault.kv.id
}
