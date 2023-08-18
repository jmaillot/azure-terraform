/* Creation of the Resource Group where all ressources will be created */

resource "azurerm_resource_group" "rg" {
   name      = var.resource_group_name
   location  = var.location
}

/* Creation of the Network Security Group that will be attached to VNET & VM Network Interface */

module "network-security-group" {
  source = "./modules/network-security-group"    
  vmname              = var.vmname
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_resource_group.rg]
}

/* Creation of the default Virtual Network and Servers Subnet */

module "virtual-network" {
  source = "./modules/virtual-network"
  virtual_network_name            = var.virtual_network_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  virtual_network_address_space   = var.virtual_network_address_space
  subnet_name                     = var.subnet_name
  subnet_address_prefixes         = var.subnet_address_prefixes
  network_security_group_id       = module.network-security-group.nsg_id
  depends_on                      = [module.network-security-group]
}

/* Creation of the network interface for the Virtual Machine */

module "network-interface" {
  source = "./modules/network-interface"    
  vmname                                = var.vmname
  location                              = var.location
  resource_group_name                   = var.resource_group_name
  subnet_id                             = module.virtual-network.subnet_id
  network_security_group_id             = module.network-security-group.nsg_id
  virtual_machine_network_interface_ip  = var.virtual_machine_network_interface_ip
  depends_on                            = [module.virtual-network]
}

/* Creation of the Virtual Machine */

module "virtual-machine" {
  source = "./modules/virtual-machine"    
  vmname                  = var.vmname
  location                = var.location
  resource_group_name     = var.resource_group_name
  network_interface_ids   = module.network-interface.nic_id
  vm_size                 = var.vm_size
  os_disk_type            = var.os_disk_type
  admin_username          = var.admin_username
  admin_password          = module.virtual-machine.admin_password
  image_publisher         = var.image_publisher
  image_offer             = var.image_offer
  image_sku               = var.image_sku
  depends_on              = [module.network-interface,module.azure-backup-policy]
}

/* Creation of the Basic VPN Gateway */

module "virtual-network-gateway" {
  source = "./modules/virtual-network-gateway"    
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  vpn_gateway_name                    = var.vpn_gateway_name
  vpn_gateway_sku                     = var.vpn_gateway_sku
  vpn_subnet_address_prefixes         = var.vpn_subnet_address_prefixes
  virtual_network_name                = var.virtual_network_name
  vpn_client_subnet_address_prefixes  = var.vpn_client_subnet_address_prefixes
  depends_on                          = [module.virtual-network]
}

/* Creation of the Recovery Services Vault */

module "azure-backup-recoveryvault" {
  source = "./modules/azure-backup-recoveryvault"    
  recovery_vault_name     = var.recovery_vault_name
  resource_group_name     = var.resource_group_name
  location                = var.location
  depends_on              = [azurerm_resource_group.rg]
}

/* Creation of the Backup Policy */

module "azure-backup-policy" {
  source = "./modules/azure-backup-policy"    
  resource_group_name            = var.resource_group_name
  backup_policy_name             = var.backup_policy_name
  recovery_vault_name            = var.recovery_vault_name
  timezone                       = var.timezone
  instant_restore_retention_days = var.instant_restore_retention_days
  backup_frequency               = var.backup_frequency
  backup_time                    = var.backup_time
  daily_count                    = var.daily_count
  weekly_count                   = var.weekly_count
  weekly_weekdays                = var.weekly_weekdays
  monthly_count                  = var.monthly_count
  monthly_weekdays               = var.monthly_weekdays
  monthly_weeks                  = var.monthly_weeks
  yearly_count                   = var.yearly_count
  yearly_weekdays                = var.yearly_weekdays
  yearly_weeks                   = var.yearly_weeks
  yearly_months                  = var.yearly_months
  depends_on                     = [module.azure-backup-recoveryvault]
}

/* Assign Backup Policy to our VM */

module "azure-backup-vm" {
  source = "./modules/azure-backup-vm"    
  recovery_vault_name     = module.azure-backup-recoveryvault.recovery_vault_name
  resource_group_name     = var.resource_group_name
  backup_policy_id        = module.azure-backup-policy.backup_policy_id
  vm_id                   = module.virtual-machine.vm_id
  depends_on              = [module.azure-backup-policy]
}
