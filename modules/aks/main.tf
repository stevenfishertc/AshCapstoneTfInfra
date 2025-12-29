data "azurerm_client_config" "current" {}

resource "azurerm_resource_provider_registration" "aks" {
  name = "Microsoft.ContainerService"
}

resource "azurerm_user_assigned_identity" "aks_uai" {
  name                = "${var.name}-uai"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  depends_on = [
    azurerm_resource_provider_registration.aks
  ]

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.name

  private_cluster_enabled = var.private_cluster_enabled

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_uai.id]
  }

  default_node_pool {
    name           = "system"
    vm_size        = var.node_vm_size
    node_count     = var.node_count
    vnet_subnet_id = var.subnet_id
    type           = "VirtualMachineScaleSets"
  }

  network_profile {
    network_plugin = "azure"
    outbound_type  = "loadBalancer"
  }

  tags = var.tags
}

# Allow AKS to pull from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  count = var.enable_rbac_assignments ? 1 : 0
  
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

# Grant AKS identity rights to read secrets from Key Vault (for CSI driver usage)
resource "azurerm_role_assignment" "aks_kv_secrets_user" {
  count = var.enable_rbac_assignments ? 1 : 0
  
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.aks_uai.principal_id
}
