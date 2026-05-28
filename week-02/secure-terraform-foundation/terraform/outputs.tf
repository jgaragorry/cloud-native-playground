output "resource_group_name" {
  value = module.resource_group.name
}

output "storage_account_name" {
  value = module.storage_account.storage_account_name
}

output "keyvault_name" {
  value = module.keyvault.keyvault_name
}

output "keyvault_uri" {
  value = module.keyvault.keyvault_uri
}
