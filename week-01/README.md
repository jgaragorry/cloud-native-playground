# Semana 01: Tu Entorno Local y Remoto

**Objetivo:** Configurar un entorno de desarrollo reproducible y seguro en WSL2 con Ubuntu 24.04, Terraform, Terragrunt, Azure CLI y AWS CLI.

## 📅 Publicaciones
- [Martes: Bootstrapping del entorno](posts/01-martes.md)
- [Miércoles: Primer despliegue en Azure con Terraform](posts/02-miercoles.md)
- [Jueves: Auditoría y destrucción forzosa](posts/03-jueves.md)

## 🧪 Laboratorios
- `labs/setup-dev-env.sh` – Script idempotente para instalar todo.
- `labs/azure-simple-storage/` – Terraform para storage account.

## ✅ Checklist de fin de semana
- [ ] Ejecuté `setup-dev-env.sh` sin errores
- [ ] Hice `az login` y `aws configure` (con credenciales de prueba)
- [ ] Desplegué el storage account y lo destruí con `terraform destroy`
- [ ] Ejecuté `scripts/destroy-all-resources.sh` para confirmar que no quedó nada
