resource "azurerm_postgresql_flexible_server" "pg" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  sku_name = var.sku_name
  version = var.pg_version
  storage_mb = var.storage_mb

  backup_retention_days  = 7
  zone                   = "1"

  delegated_subnet_id    = null
  private_dns_zone_id    = null

  # public_network_access_enabled = true

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.pg.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# Allow Azure services to access PostgreSQL
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.pg.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Disable SSL enforcement for development
resource "azurerm_postgresql_flexible_server_configuration" "require_secure_transport" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.pg.id
  value     = "off"
}
