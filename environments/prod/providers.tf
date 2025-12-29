provider "azurerm" {
  features {}
  use_cli = true
}

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.44.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "azurerm_resource_provider_registration" "aks" {
  name = "Microsoft.ContainerService"
}

resource "azurerm_resource_provider_registration" "network" {
  name = "Microsoft.Network"
}

resource "azurerm_resource_provider_registration" "apim" {
  name = "Microsoft.ApiManagement"
}

resource "azurerm_resource_provider_registration" "acr" {
  name = "Microsoft.ContainerRegistry"
}

resource "azurerm_resource_provider_registration" "kv" {
  name = "Microsoft.KeyVault"
}