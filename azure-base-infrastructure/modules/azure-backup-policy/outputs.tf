output "backup_policy_id" {
  description = "The ID of the Backup Policy."
  value       = azurerm_backup_policy_vm.AzureBackupPolicy.id
}

output "backup_policy_name" {
  description = "The name of the Backup Policy."
  value       = azurerm_backup_policy_vm.AzureBackupPolicy.name
}