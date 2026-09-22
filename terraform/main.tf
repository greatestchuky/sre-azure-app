# SRE Azure application infrastructure

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatechuky2026"
    container_name       = "tfstate"
    key                  = "sre-webapp.tfstate"
    use_azuread_auth     = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "app" {
  name     = "rg-sre-webapp"
  location = "uksouth"

  tags = {
    environment = "lab"
    managed_by  = "terraform"
    application = "sre-webapp"
    owner       = "sre-team"
  }
}

resource "azurerm_service_plan" "app" {
  name                = "asp-sre-webapp"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location

  os_type  = "Linux"
  sku_name = "F1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "sre-webapp-chuky"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_service_plan.app.location
  service_plan_id     = azurerm_service_plan.app.id

  https_only = true

  site_config {
    always_on = false

    application_stack {
      node_version = "20-lts"
    }
  }
}