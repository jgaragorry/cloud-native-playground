#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Desplegando Laboratorio #2 con Backend Remoto...${NC}"

# Verificar que existe la configuración del backend
if [ ! -f ~/.terraform-backend/lab2-backend-config ]; then
    echo -e "${YELLOW}⚠️ No se encontró configuración de backend. Ejecuta primero:${NC}"
    echo "   ./01-create-backend.sh"
    exit 1
fi

# Verificar autenticación en Azure
az account show &> /dev/null || { echo "❌ No autenticado. Ejecuta: az login"; exit 1; }

# 1. Inicializar con backend remoto
echo -e "${YELLOW}📦 Inicializando Terraform con backend remoto...${NC}"
terraform init -reconfigure \
    -backend-config=~/.terraform-backend/lab2-backend-config

# 2. Validar
echo -e "${YELLOW}✅ Validando configuración...${NC}"
terraform validate

# 3. Planificar
echo -e "${YELLOW}📋 Planificando despliegue...${NC}"
terraform plan -out=tfplan

# 4. Aplicar
echo -e "${YELLOW}🚀 Aplicando despliegue...${NC}"
terraform apply -auto-approve tfplan

# 5. Mostrar outputs
echo -e "${GREEN}✅ Despliegue completado. Outputs:${NC}"
terraform output

# 6. Ejecutar monitoreo
./03-monitor.sh

echo -e "${GREEN}🎉 Laboratorio desplegado exitosamente con backend remoto!${NC}"
