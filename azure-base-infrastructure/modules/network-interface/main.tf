resource "azurerm_network_interface" "nic" {
    name                = "${var.vmname}-NIC01"
    location            = var.location
    resource_group_name = var.resource_group_name   
    
    ip_configuration {
        name                          = "ipconfiguration1"
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = "Static"
        private_ip_address            = var.virtual_machine_network_interface_ip
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id        = azurerm_network_interface.nic.id
  network_security_group_id   = var.network_security_group_id
}