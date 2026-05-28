terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-backend-lab"
    storage_account_name = "tfbackendcnplayground"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
