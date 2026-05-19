#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}💣 INICIANDO DESTRUCCIÓN CONTROLADA DEL LABORATORIO #2${NC}"
echo -e "${YELLOW}Esto eliminará TODOS los recursos desplegados por Terraform.${NC}"
echo -e "Presiona CTRL+C para cancelar o espera 5 segundos..."
sleep 5

# Verificar configuración del backend
if [ ! -f ~/.terraform-backend/lab2-backend-config ]; then
    echo -e "${YELLOW}⚠️ No se encontró configuración de backend.${NC}"
    echo "Buscando recursos huérfanos..."
    
    # Buscar y eliminar recursos etiquetados
    RESOURCES=$(az resource list --tag "Lab=week-01-lab2" --query "[].id" -o tsv)
    if [ -n "$RESOURCES" ]; then
        echo -e "${RED}Eliminando recursos huérfanos...${NC}"
        for id in $RESOURCES; do
            echo "Eliminando: $id"
            az resource delete --ids "$id" --verbose
        done
    else
        echo -e "${GREEN}No se encontraron recursos huérfanos.${NC}"
    fi
    exit 0
fi

# 1. Ejecutar monitoreo antes de destruir
echo -e "${YELLOW}🔍 Estado antes de destrucción:${NC}"
./03-monitor.sh

# 2. Inicializar con backend remoto
echo -e "${YELLOW}📦 Conectando al backend remoto...${NC}"
terraform init -reconfigure \
    -backend-config=~/.terraform-backend/lab2-backend-config

# 3. Destruir recursos del laboratorio
echo -e "${RED}💣 Ejecutando terraform destroy...${NC}"
terraform destroy -auto-approve

# 4. Verificar que no quedaron recursos
echo -e "${YELLOW}🔍 Verificando destrucción...${NC}"
REMAINING=$(az resource list --tag "Lab=week-01-lab2" --query "length([])" -o tsv)
if [ "$REMAINING" -eq 0 ]; then
    echo -e "${GREEN}✅ Todos los recursos del laboratorio fueron destruidos.${NC}"
else
    echo -e "${RED}⚠️ Quedan $REMAINING recursos. Ejecutando limpieza forzosa...${NC}"
    ./04-destroy-all.sh --force
fi

# 5. Opción: eliminar el backend remoto (solo si se pasa --delete-backend)
if [ "$1" == "--delete-backend" ]; then
    echo -e "${RED}💣 Eliminando backend remoto...${NC}"
    source ~/.terraform-backend/lab2-backend-config
    az group delete --name "$resource_group_name" --yes --no-wait
    rm -f ~/.terraform-backend/lab2-backend-config
    echo -e "${GREEN}✅ Backend remoto eliminado.${NC}"
fi

echo -e "${GREEN}🎉 Destrucción completada. Factura a salvo.${NC}"
