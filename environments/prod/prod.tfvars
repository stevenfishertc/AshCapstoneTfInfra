project  = "capstone"
env      = "prod"
location = "eastus2"
unique_suffix  = "a1b2c"

tags = {
  owner = "students"
}

vnet_cidr        = "10.10.0.0/16"
subnet_aks_cidr  = "10.10.1.0/24"
subnet_apim_cidr = "10.10.3.0/24"
subnet_webapp_cidr = "10.10.5.0/24"

acr_sku = "Premium"

pg_admin_user     = "stevushka"
pg_admin_password = "4285Vion"
pg_db_name        = "appdb"
pg_sku_name       = "GP_Standard_D2s_v3"
pg_version        = "14"
pg_storage_mb     = 32768

aks_version      = "1.29.4"
aks_node_vm_size = "Standard_B2s"
aks_node_count   = 2
node_version     = "18-lts"

apim_publisher_name  = "Capstone Team"
apim_publisher_email = "capstone@example.com"
apim_sku_name        = "Developer_1"

enable_rbac_assignments = false
enable_keyvault_secrets = false