resource "azurerm_resource_provider_registration" "apim" {
  name = "Microsoft.ApiManagement"
}

resource "azurerm_api_management" "apim" {
  depends_on = [
    azurerm_resource_provider_registration.apim
  ]

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email

  sku_name = var.sku_name

  virtual_network_type = var.virtual_network_type

  virtual_network_configuration {
    subnet_id = var.subnet_id
  }

  tags = var.tags
}

# APIM doesn't use a Private Endpoint like KV/ACR; it sits in the VNet.
# The private DNS zone "privatelink.azure-api.net" is still useful for internal resolution
# depending on your chosen APIM endpoint configuration and internal routing.

output "gateway_url" {
  value = azurerm_api_management.apim.gateway_url
}
