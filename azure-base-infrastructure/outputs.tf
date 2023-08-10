output "admin_password" {
  description = "VM admin password"
  value = module.virtual-machine.admin_password
  sensitive   = true
}