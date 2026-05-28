locals {
  common_tags = {
    environment = var.environment
    project     = var.project_name
    owner       = "jgaragorry"
    managed-by  = "terraform"
    cost-center = "education"
  }
}
