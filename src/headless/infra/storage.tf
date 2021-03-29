resource "azurerm_storage_account" "deployment" {
  name                     = random_pet.deployment.id
  location                 = azurerm_resource_group.deployment.location
  resource_group_name      = azurerm_resource_group.deployment.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.default_tags
}

resource "azurerm_storage_share" "locust" {
  name                 = "locust"
  storage_account_name = azurerm_storage_account.deployment.name
  quota                = 50
}

resource "azurerm_storage_share_directory" "locust-logs" {
  name                 = "logs"
  share_name           = azurerm_storage_share.locust.name
  storage_account_name = azurerm_storage_account.locust.name
}

resource "azurerm_storage_share_file" "locustfile" {
  name             = "locustfile.py"
  storage_share_id = azurerm_storage_share.locust.id
  source           = "../locustfile.py"
}