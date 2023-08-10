resource "azurerm_windows_virtual_machine" "vm" {
    name                  = var.vmname
    resource_group_name   = var.resource_group_name
    location              = var.location
    size                  = var.vm_size
    admin_username        = var.admin_username
    admin_password        = random_password.password.result
    network_interface_ids = [var.network_interface_ids]
    
    os_disk {
        name                    = "${var.vmname}-OSDisk-1"
        caching                 = "ReadWrite"
        storage_account_type    = var.os_disk_type
    }    
    
    source_image_reference {
        publisher = var.image_publisher # MicrosoftWindowsServer
        offer     = var.image_offer     # WindowsServer
        sku       = var.image_sku       # 2022-Datacenter
        version   = "latest"
    }
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}