variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
  default     = "rg-cloudnative-lab"
}

variable "location" {
  description = "Región de Azure"
  type        = string
  default     = "East US"
}

variable "storage_account_name" {
  description = "Nombre del Storage Account (único global)"
  type        = string
}

variable "account_tier" {
  description = "Tier de la cuenta de almacenamiento"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Tipo de replicación"
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Etiquetas para los recursos"
  type        = map(string)
  default = {
    Environment = "lab"
    ManagedBy   = "Terraform"
    Owner       = "CloudNativePlayground"
    Lab         = "week-01-lab2"
  }
}
