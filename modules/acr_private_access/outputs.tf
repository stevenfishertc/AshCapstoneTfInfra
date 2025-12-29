output "acr_id" {
  value = data.azurerm_container_registry.acr.id
}

output "private_dns_zone_acr_id" { value = azurerm_private_dns_zone.acr.id }