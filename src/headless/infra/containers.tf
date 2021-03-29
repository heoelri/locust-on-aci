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
    image  = var.locust_version
    cpu    = "2"
    memory = "2"

    commands = [
        "locust",
        "--locustfile",
        "/home/locust/locust/${azurerm_storage_share_file.locustfile.name}",
        "--master", 
        "--headless", # running headless
        "--expect-workers",
        var.locustWorkerNodes,
        "--host",
        var.locustTargetUrl,
        "--csv",
        "locust/stats/${random_uuid.runUuid.result}",
        "--csv-full-history",
        "--users",
        var.locustNumUsers,
        "--spawn-rate",
        var.locustSpawnRate,
        "--run-time",
        "${var.locustRunTime}m",
        "--logfile",
        "/home/locust/locust/logs/${random_uuid.runUuid.result}.log"
    ]

    volume {
        name = "locust"
        mount_path = "/home/locust/locust"

        storage_account_key  = azurerm_storage_account.deployment.primary_access_key
        storage_account_name = azurerm_storage_account.deployment.name
        share_name           = azurerm_storage_share.locust.name
    }

    ports {
      port     = "5557"
      protocol = "TCP" 
    }

  }

  tags     = local.default_tags
}

resource "azurerm_container_group" "worker" {
  count               = var.locustWorkerNodes
  name                = "${random_pet.deployment.id}-locust-worker-${count.index}"
  location            = var.locust_worker_locations[count.index % length(var.locust_worker_locations)]
  resource_group_name = azurerm_resource_group.deployment.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  container {
    name   = "${random_pet.deployment.id}-worker-${count.index}"
    image  = var.locust_version
    cpu    = "2"
    memory = "2"

    commands = [
        "locust",
        "--locustfile",
        "/home/locust/locust/${azurerm_storage_share_file.locustfile.name}",
        "--worker",
        "--master-host",
        azurerm_container_group.master[0].fqdn
    ]

    volume {
        name = "locust"
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

  tags     = local.default_tags
}