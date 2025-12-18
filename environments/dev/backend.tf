terraform {
  backend "azurerm" {
    resource_group_name  = "steven-tfstate-rg"
    storage_account_name = "steventfstateaccount"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}