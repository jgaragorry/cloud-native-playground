<p align="center">
  <img src="https://img.shields.io/badge/Cloud%20Native-Playground-2ea44f?style=for-the-badge&logo=cloudflare" alt="Cloud Native Playground"/>
  <img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge" alt="License"/>
  <img src="https://img.shields.io/badge/Made%20with-Bash-1f425f.svg?style=for-the-badge&logo=gnu-bash" alt="Made with Bash"/>
  <img src="https://img.shields.io/badge/Terraform-Validated-623CE4?style=for-the-badge&logo=terraform" alt="Terraform Validated"/>
</p>

# Laboratorio #1: Bootstrap de entorno de desarrollo Cloud Native

**Objetivo:** Configurar un entorno reproducible en WSL2 con Ubuntu 24.04, Terraform, Terragrunt, AWS CLI y Azure CLI.

**Duración:** ~15 minutos

**Requisitos previos:**
- Windows 10/11 con WSL2 habilitado (también funciona en Linux/macOS nativo)
- Terminal con acceso sudo
- Conexión a internet

---

## 📋 Paso a paso

### Paso 1: Instalar/actualizar WSL2 (solo una vez, en PowerShell como administrador)

```powershell
# En PowerShell como administrador
wsl --install
# Reiniciar si es necesario
wsl --set-default-version 2
```

### Paso 2: Instalar Ubuntu 24.04 LTS
```powershell
wsl --install -d Ubuntu-24.04
```

### Paso 3: Dentro de Ubuntu, preparar el sistema

# Actualizar paquetes base
```bash
sudo apt update && sudo apt upgrade -y
```

# Instalar dependencias básicas

```bash
sudo apt install -y curl wget unzip git jq
```

### Paso 4: Descargar y ejecutar el script de bootstrap

### Descargar el script desde nuestro repositorio
```bash
curl -fsSL https://raw.githubusercontent.com/jgaragorry/cloud-native-playground/main/week-01/labs/setup-dev-env.sh -o setup-dev-env.sh
```

### Hacerlo ejecutable
```bash
chmod 750 setup-dev-env.sh
```

### Ejecutarlo
```bash
./setup-dev-env.sh
```

¿Qué hace el script?

- Instala Terraform (última versión)
- Instala Terragrunt
- Instala Azure CLI
- Instala AWS CLI v2
- Crea directorios útiles (~/lab/terraform, ~/lab/terragrunt, ~/lab/scripts)

### Paso 5: Autenticación en la nube

### Para Azure (modo dispositivo, seguro)
```bash
az login --use-device-code
```

### Para AWS (necesitas credenciales IAM)
aws configure
# Ingresa: Access Key, Secret Key, región por defecto (ej. us-east-1), output format (json)

### Paso 6: Verificar la instalación

```bash
terraform version
terragrunt --version
az version | head -2
aws --version
```

### Paso 7 (opcional): Script de auditoría local (lo usaremos el JUEVES)

Guarda esto como ~/lab/scripts/clean-env.sh:

```bash
#!/bin/bash
# Este script no borra nada de la nube (todavía), solo reporta.
echo "🔍 Auditando instalación local..."
command -v terraform && echo "✅ Terraform OK" || echo "❌ Terraform NO encontrado"
command -v terragrunt && echo "✅ Terragrunt OK" || echo "❌ Terragrunt NO encontrado"
command -v az && echo "✅ Azure CLI OK" || echo "❌ Azure CLI NO encontrado"
command -v aws && echo "✅ AWS CLI OK" || echo "❌ AWS CLI NO encontrado"
echo "✅ Auditoría completada. Para desinstalar herramientas: consulta los gestores de paquetes."
```

### 🧠 ¿Qué aprendiste?

- Cómo crear un entorno de desarrollo declarativo y reproducible.
- Instalación automatizada de herramientas cloud estándar.
- Buenas prácticas: idempotencia, verificación de comandos, autenticación segura con --use-device-code.

### 📌 Próximo laboratorio (miércoles)

Desplegaremos nuestro primer recurso en Azure usando Terraform. ¡No te lo pierdas!
