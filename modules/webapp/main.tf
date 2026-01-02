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

  site_config {
    application_stack {
      node_version = var.node_version
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "REACT_APP_API_URL"        = ""   # Will be set later via pipeline (APIM URL)
    "WEBSITES_PORT"            = "80"
  }

  tags = var.tags


  # https_only = true

  # identity {
  #   type = "SystemAssigned"
  # }

  # app_settings = {
  #   WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  #   WEBSITES_PORT                       = "80"

  #   # Container configuration (authoritative)
  #   DOCKER_CUSTOM_IMAGE_NAME   = var.container_image
  #   DOCKER_REGISTRY_SERVER_URL = var.container_registry_url
  # }
}

