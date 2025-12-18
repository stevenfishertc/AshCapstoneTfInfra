variable "name"                { type = string }
variable "location"            { type = string }
variable "resource_group_name" { type = string }
variable "tenant_id"           { type = string }
variable "tags"                { type = map(string) }

variable "enable_private_endpoint" { type = bool }
variable "pe_subnet_id"            { type = string }
variable "private_dns_zone_id"     { type = string }
