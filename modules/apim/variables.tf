variable "name"                { type = string }
variable "location"            { type = string }
variable "resource_group_name" { type = string }

variable "publisher_name"  { type = string }
variable "publisher_email" { type = string }

variable "sku_name" { type = string } # Developer_1 or Premium_1
variable "virtual_network_type" { type = string } # Internal or External
variable "subnet_id" { type = string }

variable "private_dns_zone_id" { type = string } # reserved for later patterns, optional use
variable "tags" { type = map(string) }
