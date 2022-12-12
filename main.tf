terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.34.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "Resourcegroup" {
  name     = "Resourcegroup"
  location = "East US"
}

resource "azurerm_log_analytics_workspace" "SentinelTest1" {
  name                = "SentinelTest1"
  location            = azurerm_resource_group.Resourcegroup.location
  resource_group_name = azurerm_resource_group.Resourcegroup.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_solution" "SentinelTest1" {
  solution_name         = "SecurityInsights"
  location              = azurerm_resource_group.Resourcegroup.location
  resource_group_name   = azurerm_resource_group.Resourcegroup.name
  workspace_resource_id = azurerm_log_analytics_workspace.SentinelTest1.id
  workspace_name        = azurerm_log_analytics_workspace.SentinelTest1.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}



resource "azurerm_sentinel_alert_rule_ms_security_incident" "example" {
  name                       = "example-ms-security-incident-alert-rule"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.SentinelTest1.id
  product_filter             = "Microsoft Cloud App Security"
  display_name               = "example rule"
  severity_filter            = ["High"]
}