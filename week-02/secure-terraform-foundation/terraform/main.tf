resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

module "resource_group" {
  source   = "./modules/resource-group"
  name     = "rg-cloud-native-week2"
  location = var.location
  tags     = local.common_tags
}

module "storage_account" {
  source              = "./modules/storage-account"
  name                = "stweek2${random_string.suffix.result}"
  resource_group_name = module.resource_group.name
  location            = var.location
  tags                = local.common_tags
}

module "keyvault" {
  source              = "./modules/keyvault"
  name                = "kvweek2${random_string.suffix.result}"
  resource_group_name = module.resource_group.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.common_tags
}
