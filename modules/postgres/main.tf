resource "azurerm_postgresql_flexible_server" "pg" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  version = var.pg_version
  sku_name = var.sku_name
  storage_mb = var.storage_mb

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  # Private access pattern
  delegated_subnet_id = var.delegated_subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  public_network_access_enabled = false

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.pg.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.pg.fqdn
}

output "connection_string" {
  value = "postgresql://${var.administrator_login}:${var.administrator_password}@${azurerm_postgresql_flexible_server.pg.fqdn}:5432/${var.db_name}?sslmode=require"
  sensitive = true
}
