#################################
# Azure RG & Location Variables #
#################################

variable "resource_group_name" {
    type = string
    description = "The name of resource group"
}

variable "recovery_vault_name" {
    type = string
    description = "Name of the Recovery Vault"
}

variable "backup_policy_id" {
  description = "The ID of the Backup Policy."
}

variable "vm_id" {
  type        = string
  description = "Azure Virtual Machine ID"
}