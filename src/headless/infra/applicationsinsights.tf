resource "azurerm_application_insights" "deployment" {
  name                = random_pet.deployment.id
  location            = azurerm_resource_group.deployment.location
  resource_group_name = azurerm_resource_group.deployment.name
  application_type    = "web"
  retention_in_days   = 30

  daily_data_cap_in_gb = 10

  tags = local.default_tags
}