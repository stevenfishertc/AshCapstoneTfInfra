locals {
  kubelet_object_id = var.kubelet_object_id
  acr_region        = var.location
}

# ---------- Private DNS Zones ----------
resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "acr_data" {
  name                = "privatelink.${local.acr_region}.data.azurecr.io"
  resource_group_name = var.resource_group_name
}

# ---------- VNet Links ----------
resource "azurerm_private_dns_zone_virtual_network_link" "acr_link" {
  name                  = "link-aks-acr"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_data_link" {
  name                  = "link-aks-acr-data"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr_data.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

# ---------- Private Endpoint ----------
resource "random_string" "pe_suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_private_endpoint" "acr" {
  name                = "pe-${var.acr_name}-${random_string.pe_suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.acr_name}"
    private_connection_resource_id = var.acr_id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "acr-zonegroup"

    private_dns_zone_ids = [
      azurerm_private_dns_zone.acr.id,
      azurerm_private_dns_zone.acr_data.id
    ]
  }
}

# ---------- AcrPull for AKS ----------
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = local.kubelet_object_id
}
