output "apim_gateway_url" {
  value = module.apim.gateway_url
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "keyvault_name" {
  value = module.keyvault.name
}

output "postgres_fqdn" {
  value = module.postgres.fqdn
}
