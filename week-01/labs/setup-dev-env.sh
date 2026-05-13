#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Iniciando configuración del entorno de desarrollo...${NC}"

# Instalar Terraform
if ! command -v terraform &> /dev/null; then
    echo -e "${YELLOW}📦 Instalando Terraform...${NC}"
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install -y terraform
else
    echo "✅ Terraform ya está instalado: $(terraform version)"
fi

# Instalar Terragrunt
if ! command -v terragrunt &> /dev/null; then
    echo -e "${YELLOW}📦 Instalando Terragrunt...${NC}"
    sudo wget -qO /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64
    sudo chmod +x /usr/local/bin/terragrunt
else
    echo "✅ Terragrunt ya está instalado: $(terragrunt --version)"
fi

# Instalar Azure CLI
if ! command -v az &> /dev/null; then
    echo -e "${YELLOW}📦 Instalando Azure CLI...${NC}"
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
else
    echo "✅ Azure CLI ya está instalado: $(az version --output tsv | head -1)"
fi

# Instalar AWS CLI v2
if ! command -v aws &> /dev/null; then
    echo -e "${YELLOW}📦 Instalando AWS CLI v2...${NC}"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip aws/
else
    echo "✅ AWS CLI ya está instalado: $(aws --version)"
fi

echo -e "${GREEN}🔐 Verifica que puedas autenticarte con:${NC}"
echo "   az login --use-device-code"
echo "   aws configure"

mkdir -p ~/lab/{terraform,terragrunt,scripts}

echo -e "${GREEN}✅ Entorno listo. Versiones:${NC}"
terraform version
terragrunt --version
az version | head -2
aws --version
