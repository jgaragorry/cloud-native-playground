#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Creando backend remoto para Terraform en Azure...${NC}"

# Variables únicas
SUFFIX=$(echo $RANDOM | md5sum | head -c 6)
RESOURCE_GROUP="tfstate-rg-${SUFFIX}"
STORAGE_ACCOUNT="tfstate${SUFFIX}2026"
CONTAINER_NAME="tfstate"
LOCATION="East US"

# Crear Resource Group
az group create --name $RESOURCE_GROUP --location "$LOCATION" --tags "Environment=backend" "ManagedBy=Terraform"

# Crear Storage Account
az storage account create \
    --name $STORAGE_ACCOUNT \
    --resource-group $RESOURCE_GROUP \
    --location "$LOCATION" \
    --sku Standard_LRS \
    --kind StorageV2 \
    --https-only true \
    --min-tls-version TLS1_2 \
    --allow-blob-public-access false

# Crear contenedor
az storage container create \
    --name $CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT \
    --auth-mode login

# Guardar configuración
mkdir -p ~/.terraform-backend
cat > ~/.terraform-backend/lab2-backend-config << EOF
resource_group_name  = "$RESOURCE_GROUP"
storage_account_name = "$STORAGE_ACCOUNT"
container_name       = "$CONTAINER_NAME"
key                  = "lab2.terraform.tfstate"
EOF

echo -e "${GREEN}✅ Backend creado: $STORAGE_ACCOUNT${NC}"
echo "Configuración guardada en ~/.terraform-backend/lab2-backend-config"
