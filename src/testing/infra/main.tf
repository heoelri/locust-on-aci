terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.53.0"
    }
    random = {
      version = ">= 2.2.1"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

data "azurerm_client_config" "current" {
}

# Random Pet Name (based on Resource Group Name)
resource "random_pet" "deployment" {
  separator = ""
  length    = 2
  prefix    = ""
  keepers = {
    azurerm_resource_group_location = azurerm_resource_group.deployment.location
    azurerm_resource_group_name     = azurerm_resource_group.deployment.name
  }
}

resource "azurerm_resource_group" "deployment" {
  name     = "${var.prefix}-locust-rg"
  location = var.location
  tags     = local.default_tags
}