variable "name"                { type = string }
variable "location"            { type = string }
variable "resource_group_name" { type = string }
variable "environment"         { type = string }

variable "publisher_name"  { type = string }
variable "publisher_email" { type = string }

variable "sku_name" { type = string } # Developer_1 or Premium_1
variable "virtual_network_type" { type = string } # Internal or External
variable "vnet_id" { type = string }
variable "subnet_id" { type = string }

variable "tags" { type = map(string) }

variable "subnet_ready_dependency" { type = any }
