data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "pe_subnet" {
  name                 = var.pe_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
}

locals {
  kubelet_object_id = data.azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  acr_region        = data.azurerm_container_registry.acr.location
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
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_data_link" {
  name                  = "link-aks-acr-data"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr_data.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
  registration_enabled  = false
}

# ---------- Private Endpoint ----------
resource "azurerm_private_endpoint" "acr" {
  name                = "pe-${var.acr_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "psc-${var.acr_name}"
    private_connection_resource_id = data.azurerm_container_registry.acr.id
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
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = local.kubelet_object_id
}
