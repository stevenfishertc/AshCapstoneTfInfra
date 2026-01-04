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
    vnet_route_all_enabled = false
    always_on              = true

    application_stack {
      docker_image_name   = "frontend:bootstrap"
      docker_registry_url = "https://${var.acr_login_server}"
    }

    container_registry_use_managed_identity = true
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL" = "https://${var.acr_login_server}"

    "WEBSITE_DNS_SERVER"     = "168.63.129.16"
    "WEBSITE_DNS_ALT_SERVER" = "8.8.8.8"

    # Runtime config for frontend - API URL for APIM
    "REACT_APP_API_URL" = var.api_url
  }

  lifecycle {
    ignore_changes = [
      site_config[0].application_stack[0].docker_image_name
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
