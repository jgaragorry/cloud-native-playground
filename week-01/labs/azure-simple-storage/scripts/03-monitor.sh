#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🔍 Auditando recursos desplegados por Terraform...${NC}"

# Obtener el resource group del backend
BACKEND_RG=$(az storage account list --query "[?contains(name, 'tfstate')].resourceGroup" -o tsv | head -1)

echo -e "${YELLOW}📊 Recursos gestionados por este laboratorio:${NC}"

# 1. Recursos del backend remoto
if [ -n "$BACKEND_RG" ]; then
    echo -e "${GREEN}--- Backend Remoto (NO destruir manualmente) ---${NC}"
    az resource list --resource-group "$BACKEND_RG" --query "[].{Name:name, Type:type}" -o table
fi

# 2. Recursos del laboratorio (etiquetados)
echo -e "${GREEN}--- Recursos del Laboratorio #2 ---${NC}"
az resource list --tag "Lab=week-01-lab2" --query "[].{Name:name, Type:type, RG:resourceGroup}" -o table

# 3. Contar recursos
COUNT=$(az resource list --tag "Lab=week-01-lab2" --query "length([])" -o tsv)
if [ "$COUNT" -eq 0 ]; then
    echo -e "${RED}⚠️ No se encontraron recursos del laboratorio. Puede que ya hayan sido destruidos.${NC}"
else
    echo -e "${YELLOW}Total de recursos activos del laboratorio: $COUNT${NC}"
fi

# 4. Verificar estado del backend
echo -e "${GREEN}--- Estado del Backend Remoto ---${NC}"
if [ -f ~/.terraform-backend/lab2-backend-config ]; then
    source ~/.terraform-backend/lab2-backend-config
    echo "Storage Account: $storage_account_name"
    echo "Container: $container_name"
    echo "State file: $key"
    
    # Verificar si el state file existe
    az storage blob exists \
        --account-name "$storage_account_name" \
        --container-name "$container_name" \
        --name "$key" \
        --auth-mode login --query "exists" -o tsv
fi

echo -e "${GREEN}✅ Auditoría completada.${NC}"
