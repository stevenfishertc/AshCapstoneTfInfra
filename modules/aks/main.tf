data "azurerm_client_config" "current" {}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.name

  # kubernetes_version  = var.kubernetes_version
  
  identity {
    type         = "SystemAssigned"
  }

  default_node_pool {
    name                   = "stevensystem"
    vm_size                = var.node_vm_size
    node_count             = var.node_count
    vnet_subnet_id         = var.subnet_id
    type                   = "VirtualMachineScaleSets"
    temporary_name_for_rotation = "steventmp"
  }

  network_profile {
    network_plugin = "azure"
  }

  tags = var.tags
}

# Allow AKS to pull from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  # count = var.enable_rbac_assignments ? 1 : 0
  
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
