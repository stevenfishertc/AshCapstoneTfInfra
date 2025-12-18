variable "project" { type = string }
variable "env"     { type = string }
variable "location" { type = string }

variable "tenant_id" { type = string }

variable "unique_suffix" {
  type        = string
  description = "Short suffix to make globally-unique names (e.g. 4-6 chars)."
}

variable "tags" {
  type    = map(string)
  default = {}
}

# Networking
variable "vnet_cidr"        { type = string }
variable "subnet_aks_cidr"  { type = string }
variable "subnet_pe_cidr"   { type = string }
variable "subnet_apim_cidr" { type = string }
variable "subnet_pg_cidr"   { type = string }

# ACR
variable "acr_sku" { type = string } # Basic/Standard/Premium
variable "acr_private_endpoint_enabled" { 
  type = bool 
  default = false 
}

# Postgres
variable "pg_admin_user"     { type = string }
variable "pg_admin_password" { 
  type = string 
  sensitive = true 
}
variable "pg_db_name"        { type = string }
variable "pg_sku_name"       { type = string } # e.g. GP_Standard_D2s_v3
variable "pg_version"        { 
  type = string 
  default = "16" 
}
variable "pg_storage_mb"     { 
  type = number 
  default = 32768 
}

# AKS
variable "aks_version"       { type = string }
variable "aks_node_vm_size"  { type = string }
variable "aks_node_count"    { type = number }

# APIM
variable "apim_publisher_name"  { type = string }
variable "apim_publisher_email" { type = string }
variable "apim_sku_name"        { type = string } # Developer_1 or Premium_1
