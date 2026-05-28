data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  purge_protection_enabled      = true
  soft_delete_retention_days    = 7
  enable_rbac_authorization     = true
  public_network_access_enabled = true

  tags = var.tags
}

resource "azurerm_role_assignment" "keyvault_admin" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "lab_secret" {
  name         = "lab-storage-secret"
  value        = "cloud-native-secret"
  key_vault_id = azurerm_key_vault.this.id

  depends_on = [
    azurerm_role_assignment.keyvault_admin
  ]
}
