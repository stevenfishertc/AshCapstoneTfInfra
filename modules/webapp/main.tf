resource "azurerm_service_plan" "plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type  = "Linux"
  sku_name = "B1"

  tags = var.tags
}

resource "azurerm_linux_web_app" "webapp" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.plan.id

  virtual_network_subnet_id = var.webapp_subnet_id

  site_config {
    vnet_route_all_enabled = true

    linux_fx_version = "DOCKER|${var.acr_login_server}/frontend:bootstrap"

    # Optional but recommended
    always_on = true
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    # 🔴 REMOVE ALL Node / Package settings
    "WEBSITE_DNS_SERVER"     = "168.63.129.16"
    "WEBSITE_DNS_ALT_SERVER" = "8.8.8.8"

    # Optional runtime config for frontend
    "REACT_APP_API_URL" = ""
  }

  lifecycle {
    ignore_changes = [
      site_config[0].linux_fx_version
    ]
  }

  tags = var.tags
}


# Allow Webapp to pull from ACR
resource "azurerm_role_assignment" "webapp_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.webapp.identity[0].principal_id
}
