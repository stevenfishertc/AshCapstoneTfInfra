data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  public_network_access_enabled = false

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  tags = var.tags
}

# Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "kv" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "pe-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pe_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.name}"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names             = ["vault"]
    is_manual_connection          = false
  }
}

resource "azurerm_private_dns_zone_group" "kv" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "pdzg-kv"
  private_endpoint_id = azurerm_private_endpoint.kv[0].id
  private_dns_zone_ids = [var.private_dns_zone_id]
}

output "id"   { value = azurerm_key_vault.kv.id }
output "name" { value = azurerm_key_vault.kv.name }
