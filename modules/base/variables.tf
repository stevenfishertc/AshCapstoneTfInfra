variable "location"            { type = string }
variable "resource_group_name" { type = string }
variable "vnet_name"           { type = string }
variable "vnet_cidr"           { type = string }

variable "subnet_aks_cidr"      { type = string }
variable "subnet_pe_cidr"       { type = string }
variable "subnet_apim_cidr"     { type = string }
variable "subnet_pg_cidr"       { type = string }

variable "private_dns_zones" {
  type = object({
    keyvault = string
    acr      = string
    apim     = string
  })
}

variable "tags" { type = map(string) }
