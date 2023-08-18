resource "azurerm_recovery_services_vault" "vault" {
  recovery_vault_name = "${var.resource_group_name}-BackupVault"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.vault_sku
  soft_delete_enabled = var.soft_delete_enabled
}