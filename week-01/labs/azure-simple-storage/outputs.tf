output "resource_group_name" {
  description = "Nombre del Resource Group"
  value       = azurerm_resource_group.lab.name
}

output "storage_account_name" {
  description = "Nombre del Storage Account"
  value       = azurerm_storage_account.lab.name
}

output "storage_account_id" {
  description = "ID del Storage Account"
  value       = azurerm_storage_account.lab.id
}

output "primary_blob_endpoint" {
  description = "Endpoint del blob storage"
  value       = azurerm_storage_account.lab.primary_blob_endpoint
}
