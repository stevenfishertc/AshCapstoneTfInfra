project  = "capstone"
env      = "dev"
location = "eastus"

# tenant_id_      = "104e77d4-81e7-4c16-ab44-935220bed6dd"
unique_suffix  = "a1b2c"

tags = {
  owner = "students"
}

vnet_cidr        = "10.10.0.0/16"
subnet_aks_cidr  = "10.10.1.0/24"
subnet_pe_cidr   = "10.10.2.0/24"
subnet_apim_cidr = "10.10.3.0/24"
subnet_pg_cidr   = "10.10.4.0/24"

acr_sku = "Premium"
acr_private_endpoint_enabled = true

pg_admin_user     = "stevushka"
pg_admin_password = "4285Vion"
pg_db_name        = "appdb"
pg_sku_name       = "GP_Standard_D2s_v3"
pg_version        = "16"
pg_storage_mb     = 32768

aks_version      = "1.29.4"
aks_node_vm_size = "Standard_D4s_v5"
aks_node_count   = 2

apim_publisher_name  = "Capstone Team"
apim_publisher_email = "capstone@example.com"
apim_sku_name        = "Developer_1"

enable_rbac_assignments = false
enable_keyvault_secrets = false