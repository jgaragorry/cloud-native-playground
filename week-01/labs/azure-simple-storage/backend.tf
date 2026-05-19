# backend.tf - Configuración de backend remoto en Azure
# IMPORTANTE: Este archivo NO debe versionarse con valores reales
# Los valores se pasan mediante -backend-config en tiempo de ejecución

terraform {
  backend "azurerm" {
    # Los valores se proveen mediante script
    # resource_group_name  = "tfstate-rg"
    # storage_account_name = "tfsateXXXX" 
    # container_name       = "tfstate"
    # key                  = "lab2.terraform.tfstate"
  }
}
