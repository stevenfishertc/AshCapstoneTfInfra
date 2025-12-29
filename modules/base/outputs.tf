output "resource_group_name" { value = azurerm_resource_group.rg.name }
output "vnet_id"             { value = azurerm_virtual_network.vnet.id }
output "location"            { value = azurerm_resource_group.rg.location }

output "subnet_aks_id" { value = azurerm_subnet.aks.id }
output "subnet_private_endpoints_id" { value = azurerm_subnet.private_endpoints.id }
output "subnet_apim_id" { value = azurerm_subnet.apim.id }
output "subnet_postgres_delegated_id" { value = azurerm_subnet.postgres_delegated.id }

# output "private_dns_zone_keyvault_id" { value = azurerm_private_dns_zone.kv.id }
output "private_dns_zone_apim_id"     { value = azurerm_private_dns_zone.apim.id }
output "private_dns_zone_postgres_id" { value = azurerm_private_dns_zone.postgres.id }
