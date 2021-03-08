/**
  * # Azure Kubernetes Service - Global
  *
  * This module is used to create resources that are used by AKS clusters.
  */

terraform {
  required_version = "0.14.7"

  required_providers {
    azurerm = {
      version = "2.50.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "1.4.0"
      source  = "hashicorp/azuread"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

data "azurerm_resource_group" "this" {
  name = "rg-${var.environment}-${var.location_short}-${var.name}"
}
