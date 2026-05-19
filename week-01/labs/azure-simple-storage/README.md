# Laboratorio #2: Despliegue de Storage Account en Azure con Terraform

**Objetivo:** Crear un Resource Group y un Storage Account en Azure usando Terraform.

**Duración:** ~20 minutos

**Requisitos previos:**
- Laboratorio #1 completado (Terraform + Azure CLI instalados)
- `az login` ejecutado y autenticado
- Suscripción de Azure activa (Free Tier funciona)

---

## 📋 Paso a paso

### Paso 1: Crear la carpeta del laboratorio

```bash
mkdir -p ~/lab/terraform/azure-storage
cd ~/lab/terraform/azure-storage
```

### Paso 2: Crear los archivos Terraform
main.tf
```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "lab" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "lab" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.lab.name
  location                 = azurerm_resource_group.lab.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags                     = var.tags
}
```

variables.tf
```hcl
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
```

outputs.tf
```hcl
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
```

terraform.tfvars.example
```hcl
# Copia este archivo como terraform.tfvars y completa los valores
resource_group_name   = "rg-cloudnative-lab"
location              = "East US"
storage_account_name  = "stcloudnatvelabXXXX"  # <-- CAMBIA XXXX por un número único
account_tier          = "Standard"
account_replication_type = "LRS"
```

### Paso 3: Inicializar Terraform
```bash
terraform init
```
### Paso 4: Validar la configuración
```bash
terraform validate
```
### Paso 5: Planificar el despliegue
```bash
terraform plan
```
### Paso 6: Aplicar el despliegue
```bash
terraform apply -auto-approve
```
### Paso 7: Verificar desde Azure CLI
# Listar resource groups
```bash
az group list --query "[?contains(name, 'rg-cloudnative')]" -o table
```

### Ver detalles del storage account
```bash
az storage account show --name <tu-storage-account-name> --resource-group rg-cloudnative-lab
```
### Paso 8: DESTRUIR TODO (importante)
```bash
terraform destroy -auto-approve
```
### Paso 9: Verificar destrucción
```bash
az group list --query "[?contains(name, 'rg-cloudnative')]" -o table
```
### Debe mostrar 0 resultados
🧠 ¿Qué aprendiste?

- Cómo estructurar un proyecto Terraform para Azure
- Uso de variables para código reutilizable
- Outputs para exponer información útil
- Tags para identificar recursos de laboratorio
- Destrucción controlada para evitar costes

### ⚠️ ¡Cuidado con los costes!

- El Storage Account en Standard/LRS tiene costo muy bajo (centavos)
- Siempre ejecuta terraform destroy al terminar
- Verifica con az group list que no quedaron recursos
- 📌 Próximo laboratorio (jueves)

---

## 📌 Próximo laboratorio (jueves)

Script de auditoría y destrucción forzosa de recursos huérfanos (FinOps).

🚀 ¿Ya completaste este laboratorio? Cuéntame cómo te fue en los comentarios del post.
