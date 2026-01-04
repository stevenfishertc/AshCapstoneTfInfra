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
  subnet_apim_cidr     = var.subnet_apim_cidr
  subnet_webapp_cidr   = var.subnet_webapp_cidr

  tags = local.tags
}

module "acr" {
  source              = "../../modules/acr"
  name                = "acr${replace(local.name_prefix, "-", "")}${var.unique_suffix}"
  location            = var.location
  resource_group_name = module.base.resource_group_name
  sku                 = var.acr_sku
  admin_enabled       = false

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

  enable_rbac_assignments = var.enable_rbac_assignments

  node_vm_size           = var.aks_node_vm_size
  node_count             = var.aks_node_count

  tags = local.tags
}

module "webapp" {
  source = "../../modules/webapp"

  name                = "stevens-webapp-frontend-prod"
  location            = var.location
  resource_group_name = module.base.resource_group_name

  webapp_subnet_id    = module.base.subnet_webapp_id

  acr_id              = module.acr.id
  acr_login_server    = module.acr.login_server

  api_url             = "https://apim-capstone-prod-a1b2c.privatelink.azure-api.net"

  node_version = var.node_version

  app_service_plan_name = "steven-app-service-plan-prod"

  container_registry_url = "https://${module.acr.login_server}"

  tags = var.tags
}


module "apim" {
  source              = "../../modules/apim"
  name                = "apim-${local.name_prefix}-${var.unique_suffix}"
  location            = var.location
  resource_group_name = module.base.resource_group_name
  environment         = var.env

  publisher_name  = var.apim_publisher_name
  publisher_email = var.apim_publisher_email
  sku_name        = var.apim_sku_name # Developer_1 or Premium_1
  virtual_network_type = "External"
  vnet_id              = module.base.vnet_id

  subnet_id              = module.base.subnet_apim_id

  subnet_ready_dependency = module.base.vnet_id

  tags = local.tags
}
