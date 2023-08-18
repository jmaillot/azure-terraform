output "admin_password" {
  sensitive = true
  value     = azurerm_windows_virtual_machine.vm.admin_password
}

output "vm_id" {
  value     = azurerm_windows_virtual_machine.vm.id
}