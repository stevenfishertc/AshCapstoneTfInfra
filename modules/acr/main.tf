resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  tags                = var.tags
}

resource "azurerm_private_endpoint" "acr" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "pe-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pe_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.name}"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names             = ["registry"]
    is_manual_connection          = false
  }
}

resource "azurerm_private_endpoint_dns_zone_group" "acr" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "pdzg-acr"
  private_endpoint_id = azurerm_private_endpoint.acr[0].id

  private_dns_zone_ids = [var.private_dns_zone_id]
}
