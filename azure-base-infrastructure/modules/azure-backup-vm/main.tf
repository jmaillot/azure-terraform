resource "azurerm_backup_protected_vm" "protected_vm" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_vault_name
  backup_policy_id    = var.backup_policy_id
  source_vm_id        = var.vm_id
}