resource "azurerm_container_group" "master" {
  count               = var.locustWorkerNodes >= 1 ? 1 : 0
  name                = "${random_pet.deployment.id}-locust-master"
  location            = azurerm_resource_group.deployment.location
  resource_group_name = azurerm_resource_group.deployment.name
  ip_address_type     = "Public"
  dns_name_label      = "${random_pet.deployment.id}-locust-master"
  os_type             = "Linux"

  container {
    name   = "${random_pet.deployment.id}-locust-master"
    image  = var.locust_container_image
    cpu    = "2"
    memory = "2"

    commands = [
      "locust"
    ]

    environment_variables = {
      "LOCUST_LOCUSTFILE"              = "/home/locust/locust/${azurerm_storage_share_file.locustfile.name}",
      "LOCUST_HOST"                    = var.targeturl,
      "LOCUST_MODE_MASTER"             = "true"
      "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.deployment.instrumentation_key
    }

    secure_environment_variables = {
      "LOCUST_WEB_AUTH" = "locust:${azurerm_key_vault_secret.locustsecret.value}"
    }

    volume {
      name       = "locust"
      mount_path = "/home/locust/locust"

      storage_account_key  = azurerm_storage_account.deployment.primary_access_key
      storage_account_name = azurerm_storage_account.deployment.name
      share_name           = azurerm_storage_share.locust.name
    }

    ports {
      port     = "8089"
      protocol = "TCP"
    }

    ports {
      port     = "5557"
      protocol = "TCP"
    }

  }

  tags = local.default_tags
}

resource "azurerm_container_group" "worker" {
  count               = var.locustWorkerNodes
  name                = "${random_pet.deployment.id}-locust-worker-${count.index}"
  location            = var.locustWorkerLocations[count.index % length(var.locustWorkerLocations)]
  resource_group_name = azurerm_resource_group.deployment.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  container {
    name   = "${random_pet.deployment.id}-worker-${count.index}"
    image  = var.locust_container_image
    cpu    = "2"
    memory = "2"

    commands = [
      "locust"
    ]

    environment_variables = {
      "LOCUST_LOCUSTFILE"              = "/home/locust/locust/${azurerm_storage_share_file.locustfile.name}",
      "LOCUST_MASTER_NODE_HOST"        = azurerm_container_group.master[0].fqdn,
      "LOCUST_MODE_WORKER"             = "true"
      "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.deployment.instrumentation_key
    }

    volume {
      name       = "locust"
      mount_path = "/home/locust/locust"

      storage_account_key  = azurerm_storage_account.deployment.primary_access_key
      storage_account_name = azurerm_storage_account.deployment.name
      share_name           = azurerm_storage_share.locust.name
    }

    ports {
      port     = 8089
      protocol = "TCP"
    }

  }

  tags = local.default_tags
}