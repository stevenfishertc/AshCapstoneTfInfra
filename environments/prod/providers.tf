provider "azurerm" {
  subscription_id = "606e824b-aaf7-4b4e-9057-b459f6a4436d"
  features {}
  use_cli = true
}

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.118"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}