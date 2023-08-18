#################################
# Azure RG & Location Variables #
#################################

variable "resource_group_name" {
    type = string
    description = "resource group name"
}

variable "location" {
    type = string
    description = "location of the resources"
}

##################################
# Azure Recovery Vault Variables #
##################################

variable "recovery_vault_name" {
    type = string
    description = "Name of the Recovery Vault"
}

variable "vault_sku" {
    type = string
    description = "Sku of the Recovery Services vault"
    default = "Standard"
}

variable soft_delete_enabled {
  description = "Is soft delete enable for this Vault?"
  type        = bool
  default     = true
}