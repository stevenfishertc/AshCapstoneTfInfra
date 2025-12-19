variable "name"                { type = string }
variable "location"            { type = string }
variable "resource_group_name" { type = string }

variable "enable_rbac_assignments" { type = bool }

variable "kubernetes_version" { type = string }
variable "subnet_id"          { type = string }

variable "private_cluster_enabled" { type = bool }

variable "node_vm_size" { type = string }
variable "node_count"   { type = number }

variable "acr_id"      { type = string }
variable "keyvault_id" { type = string }

variable "tags" { type = map(string) }
