locals {
  name_prefix = "${var.project}-${var.env}"
  tags = merge(var.tags, {
    env     = var.env
    project = var.project
  })
}

module "base" {
  source              = "../../modules/base"
  location            = var.location
  resource_group_name = "rg-${local.name_prefix}"
  vnet_name           = "vnet-${local.name_prefix}"
  vnet_cidr           = var.vnet_cidr

  subnet_aks_cidr      = var.subnet_aks_cidr
  subnet_pe_cidr       = var.subnet_pe_cidr
  subnet_apim_cidr     = var.subnet_apim_cidr
  subnet_pg_cidr       = var.subnet_pg_cidr

  private_dns_zones = {
    keyvault = "privatelink.vaultcore.azure.net"
    acr      = "privatelink.azurecr.io"
    apim     = "privatelink.azure-api.net"
    postgres = "privatelink.postgres.database.azure.com"
  }

  tags = local.tags
}

module "acr" {
  source              = "../../modules/acr"
  name                = "acr${replace(local.name_prefix, "-", "")}${var.unique_suffix}"
  location            = var.location
  resource_group_name = module.base.resource_group_name
  sku                 = var.acr_sku
  admin_enabled       = true

  enable_private_endpoint = var.acr_private_endpoint_enabled
  pe_subnet_id            = module.base.subnet_private_endpoints_id
  private_dns_zone_id     = module.acr_private_access.private_dns_zone_acr_id

  tags = local.tags
}

module "keyvault" {
  source              = "../../modules/keyvault"
  name                = "kv-${local.name_prefix}-${var.unique_suffix}"
  location            = var.location
  resource_group_name = module.base.resource_group_name
  tenant_id           = var.tenant_id

  enable_private_endpoint = true
  pe_subnet_id            = module.base.subnet_private_endpoints_id

  tags = local.tags
}

module "postgres" {
  source              = "../../modules/postgres"
  name                = "psql-${local.name_prefix}-${var.unique_suffix}"
  location            = var.location
  resource_group_name = module.base.resource_group_name

  administrator_login    = var.pg_admin_user
  administrator_password = var.pg_admin_password
  db_name                = var.pg_db_name
  sku_name               = var.pg_sku_name
  pg_version             = var.pg_version
  storage_mb             = var.pg_storage_mb

  # Private access mode (delegated subnet)
  delegated_subnet_id = module.base.subnet_postgres_delegated_id
  private_dns_zone_id = module.base.private_dns_zone_postgres_id

  tags = local.tags
}

module "aks" {
  source              = "../../modules/aks"
  name                = "aks-${local.name_prefix}"
  location            = var.location
  resource_group_name = module.base.resource_group_name
  kubernetes_version  = var.aks_version

  subnet_id              = module.base.subnet_aks_id
  private_cluster_enabled = false

  # Integrations
  acr_id                 = module.acr.id
  keyvault_id            = module.keyvault.id

  enable_rbac_assignments = var.enable_rbac_assignments

  node_vm_size           = var.aks_node_vm_size
  node_count             = var.aks_node_count

  tags = local.tags
}

module "acr_private_access" {
  source = "../../modules/acr_private_access"

  resource_group_name = module.base.resource_group_name
  location = module.base.location

  vnet_id         = module.base.vnet_id
  pe_subnet_id    = module.base.subnet_private_endpoints_id
  acr_id          = module.acr.id
  acr_name        = module.acr.name

  kubelet_object_id = module.aks.kubelet_id
}

module "webapp" {
  source = "../../modules/webapp"

  name                = "stevens-webapp-frontend-prod"
  location            = var.location
  resource_group_name = module.base.resource_group_name

  app_service_plan_name = "steven-app-service-plan-prod"

  container_registry_url = "https://apim-capstone-prod-a1b2c.azure-api.net"

  tags = var.tags
}


module "apim" {
  source              = "../../modules/apim"
  name                = "apim-${local.name_prefix}-${var.unique_suffix}"
  location            = var.location
  resource_group_name = module.base.resource_group_name

  publisher_name  = var.apim_publisher_name
  publisher_email = var.apim_publisher_email
  sku_name        = var.apim_sku_name # Developer_1 or Premium_1
  virtual_network_type = "Internal"

  subnet_id              = module.base.subnet_apim_id
  private_dns_zone_id    = module.base.private_dns_zone_apim_id

  tags = local.tags
}

# Store connection strings in Key Vault (env-specific)
resource "azurerm_key_vault_secret" "pg_conn_string" {
  count = var.enable_keyvault_secrets ? 1 : 0

  name         = "postgres-conn-string"
  value        = module.postgres.connection_string
  key_vault_id = module.keyvault.id
  depends_on   = [module.keyvault, module.postgres]
}

locals {
  postgres_conn_string = var.enable_keyvault_secrets ? azurerm_key_vault_secret.pg_conn_string[0].value : null
}