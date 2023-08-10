resource "azurerm_resource_group" "rg" {
   name      = var.resource_group_name
   location  = var.location
}

module "network-security-group" {
  source = "./modules/network-security-group"    
  vmname              = var.vmname
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_resource_group.rg]
}

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
  depends_on              = [module.network-interface]
}

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


/* module "install-rds" {
  source = "./modules/install-rds"
  virtual_machine_id = module.virtual-machine.vm_id
} */

