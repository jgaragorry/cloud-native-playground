variable "project_name" {
  type        = string
  description = "Project name"

  validation {
    condition     = length(var.project_name) > 3
    error_message = "Project name is too short."
  }
}

variable "backend_storage_account_name" {
  type        = string
  description = "Terraform backend storage account"
}

variable "location" {
  type        = string
  description = "Azure deployment region"
  default     = "eastus"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "lab"

  validation {
    condition = contains(
      ["dev", "qa", "prod", "lab"],
      var.environment
    )

    error_message = "Environment must be dev, qa, prod or lab."
  }
}
