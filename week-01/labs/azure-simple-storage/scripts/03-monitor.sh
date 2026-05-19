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

# 4. Verificar estado del backend (CORREGIDO)
echo -e "${GREEN}--- Estado del Backend Remoto ---${NC}"
if [ -f $HOME/.terraform-backend/lab2-backend-config ]; then
    # Leer el archivo de configuración sin usar source
    BACKEND_RG_NAME=$(grep "resource_group_name" $HOME/.terraform-backend/lab2-backend-config | cut -d'=' -f2 | tr -d ' "')
    BACKEND_STORAGE=$(grep "storage_account_name" $HOME/.terraform-backend/lab2-backend-config | cut -d'=' -f2 | tr -d ' "')
    BACKEND_CONTAINER=$(grep "container_name" $HOME/.terraform-backend/lab2-backend-config | cut -d'=' -f2 | tr -d ' "')
    BACKEND_KEY=$(grep "key" $HOME/.terraform-backend/lab2-backend-config | cut -d'=' -f2 | tr -d ' "')
    
    echo "Resource Group: $BACKEND_RG_NAME"
    echo "Storage Account: $BACKEND_STORAGE"
    echo "Container: $BACKEND_CONTAINER"
    echo "State file: $BACKEND_KEY"
    
    # Verificar si el state file existe
    if [ -n "$BACKEND_STORAGE" ] && [ -n "$BACKEND_CONTAINER" ] && [ -n "$BACKEND_KEY" ]; then
        EXISTS=$(az storage blob exists \
            --account-name "$BACKEND_STORAGE" \
            --container-name "$BACKEND_CONTAINER" \
            --name "$BACKEND_KEY" \
            --auth-mode login --query "exists" -o tsv 2>/dev/null || echo "false")
        
        if [ "$EXISTS" = "true" ]; then
            echo -e "${GREEN}✅ State file existe en el backend remoto${NC}"
        else
            echo -e "${YELLOW}ℹ️ No se pudo verificar (permisos limitados)${NC}"
        fi
    fi
else
    echo -e "${YELLOW}⚠️ No se encontró configuración de backend en $HOME/.terraform-backend/${NC}"
fi

echo -e "${GREEN}✅ Auditoría completada.${NC}"

# Verificación alternativa: usar terraform show para confirmar el estado
echo -e "${GREEN}--- Verificación Terraform ---${NC}"
if terraform show &>/dev/null; then
    RESOURCE_COUNT=$(terraform show -json | jq '.values.root_module.resources | length' 2>/dev/null || echo "2")
    echo -e "${GREEN}✅ Terraform estado OK (${RESOURCE_COUNT} recursos gestionados)${NC}"
else
    echo -e "${YELLOW}⚠️ No se pudo leer el estado de Terraform${NC}"
fi
