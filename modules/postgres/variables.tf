variable "name"                { type = string }
variable "location"            { type = string }
variable "resource_group_name" { type = string }

variable "administrator_login"    { type = string }
variable "administrator_password" { 
    type = string 
    sensitive = true 
}
variable "db_name"                { type = string }

variable "sku_name"    { type = string }
variable "version"     { type = string }
variable "storage_mb"  { type = number }

variable "delegated_subnet_id" { type = string }
variable "private_dns_zone_id" { type = string }

variable "tags" { type = map(string) }
