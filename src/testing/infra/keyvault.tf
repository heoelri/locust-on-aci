resource "azurerm_key_vault" "deployment" {
  name                        = random_pet.deployment.id
  location                    = azurerm_resource_group.deployment.location
  resource_group_name         = azurerm_resource_group.deployment.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = []

    secret_permissions = [
      "Get",
      "Set",
      "List"
    ]

    storage_permissions = []
  }
}

resource "random_password" "locustsecret" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "locustsecret" {
  name         = "locust-webauth-secret"
  value        = random_password.locustsecret.result
  key_vault_id = azurerm_key_vault.deployment.id
}