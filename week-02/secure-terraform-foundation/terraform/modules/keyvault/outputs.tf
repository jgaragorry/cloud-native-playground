output "keyvault_name" {
  value = azurerm_key_vault.this.name
}

output "keyvault_uri" {
  value = azurerm_key_vault.this.vault_uri
}
