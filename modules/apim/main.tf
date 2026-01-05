resource "azurerm_api_management" "apim" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email

  sku_name = var.sku_name

  public_network_access_enabled = true

  depends_on = [
    var.subnet_ready_dependency
  ]

  timeouts {
    create = "2h"
    update = "2h"
    delete = "2h"
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "apim_gateway" {
  name                = "apim-gateway-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "apim-gateway-priv-conn"
    private_connection_resource_id = azurerm_api_management.apim.id
    subresource_names              = ["Gateway"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# APIM doesn't use a Private Endpoint like KV/ACR; it sits in the VNet.
# The private DNS zone "privatelink.azure-api.net" is still useful for internal resolution
# depending on your chosen APIM endpoint configuration and internal routing.

output "gateway_url" {
  value = azurerm_api_management.apim.gateway_url
}

resource "azurerm_api_management_api" "backend_a" {
  name                = "backend-a-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name

  revision      = "1"
  display_name = "Backend A API"
  path         = "api/a"
  protocols    = ["https"]
  subscription_required = false

  # Use AKS ingress LoadBalancer IP if provided, otherwise placeholder
  service_url  = var.aks_ingress_ip != "" ? "http://${var.aks_ingress_ip}" : "http://placeholder.local"
}

resource "azurerm_api_management_api_operation" "backend_a_post" {
  operation_id        = "backend-a-post"
  api_name           = azurerm_api_management_api.backend_a.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name       = "POST to Backend A"
  method             = "POST"
  url_template       = "/"
  description        = "Forward POST requests to backend A"
}

resource "azurerm_api_management_api" "backend_b" {
  name                = "backend-b-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name

  revision      = "1"
  display_name = "Backend B API"
  path         = "api/b"
  protocols    = ["https"]
  subscription_required = false

  # Use AKS ingress LoadBalancer IP if provided, otherwise placeholder
  service_url  = var.aks_ingress_ip != "" ? "http://${var.aks_ingress_ip}" : "http://placeholder.local"
}

resource "azurerm_api_management_api_operation" "backend_b_post" {
  operation_id        = "backend-b-post"
  api_name           = azurerm_api_management_api.backend_b.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name       = "POST to Backend B"
  method             = "POST"
  url_template       = "/"
  description        = "Forward POST requests to backend B"
}

resource "azurerm_private_dns_zone" "apim" {
  name                = "privatelink.azure-api.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "apim_link" {
  name                  = "apim-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.apim.name
  virtual_network_id    = var.vnet_id
}
