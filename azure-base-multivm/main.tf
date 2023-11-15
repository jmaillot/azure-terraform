/* Creation of the Resource Group where all ressources will be created */

resource "azurerm_resource_group" "rg" {
   name      = var.resource_group_name
   location  = var.location
}

/* Creation of the Network Security Group that will be attached to VNET */

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.virtual_network_name}-NSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name   
  depends_on          = [azurerm_resource_group.rg]
}

/* Creation of the default Virtual Network and Servers Subnet */

resource "azurerm_virtual_network" "vnet" {
  name                        = var.virtual_network_name
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  address_space               = var.virtual_network_address_space
  depends_on                  = [azurerm_resource_group.rg]
}

/* Creation of the first subnet within that VNET  (Server Subnet) */
resource "azurerm_subnet" "srvsubnet" {
    name                      = var.subnet_name
    resource_group_name       = azurerm_resource_group.rg.name
    virtual_network_name      = var.virtual_network_name
    address_prefixes          = var.subnet_address_prefixes
    depends_on                = [azurerm_virtual_network.vnet]
}

/* Associate the previously created NSG with the VNET */

resource "azurerm_subnet_network_security_group_association" "example" {
    subnet_id                 = azurerm_subnet.srvsubnet.id
    network_security_group_id = azurerm_network_security_group.nsg.id
    depends_on                = [azurerm_network_security_group.nsg]
}

/* Creation of the network interface for the Virtual Machine */

resource "azurerm_network_interface" "vm_nic" {
  for_each = var.vm_map

  name                = "${each.value.vm_name}-NIC01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name  
    
  ip_configuration {
    name                          = "ipconfiguration1"
    subnet_id                     = azurerm_subnet.srvsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value.vm_ip
  }
  depends_on          = [azurerm_resource_group.rg]
}

/* Creation of the Virtual Machine */

resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.vm_map

  name                  = each.value.vm_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = each.value.vm_size
  admin_username        = var.admin_username
  admin_password        = each.value.vm_password #random_password.password.result
  secure_boot_enabled   = true
  vtpm_enabled          = true
  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]
    
  os_disk {
    name                    = "${each.value.vm_name}-OSDisk-1"
    caching                 = "ReadWrite"
    storage_account_type    = var.os_disk_type
  }    
  source_image_reference {
    publisher = var.image_publisher # MicrosoftWindowsServer
    offer     = var.image_offer     # WindowsServer
    sku       = var.image_sku       # 2022-Datacenter
    version   = "latest"
  }
  depends_on              = [azurerm_network_interface.vm_nic]
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}

/* Creation of the Network Interface for the VPN GAteway */

resource "azurerm_public_ip" "ippub" {
  name                = "${var.vpn_gateway_name}-IP"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
 
  allocation_method = "Dynamic"
  depends_on          = [azurerm_resource_group.rg]
}

/* Creation of the Subnet for the VPN GAteway */

resource "azurerm_subnet" "vpnsubnet" {
  name                      = "GatewaySubnet"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  address_prefixes          = var.vpn_subnet_address_prefixes
  depends_on                = [azurerm_virtual_network.vnet]
}

/* Creation of the Basic VPN Gateway */

resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = var.vpn_gateway_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  type     = "Vpn"
  vpn_type = "RouteBased"
 
  active_active = false
  enable_bgp    = false
  sku           = var.vpn_gateway_sku

  ip_configuration {
    name                          = "ipconfigurationgw1"
    public_ip_address_id          = azurerm_public_ip.ippub.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.vpnsubnet.id
  }

  vpn_client_configuration {
    address_space = var.vpn_client_subnet_address_prefixes #["10.2.0.0/24"]

    root_certificate {
      name = "BUMODERNWorkplace_AZVPNRootCA"
      public_cert_data = <<EOF
MIIDCzCCAfOgAwIBAgIQLk0oelUwF4dJMYSjvCxlzTANBgkqhkiG9w0BAQsFADAo
MSYwJAYDVQQDDB1CVU1PREVSTldvcmtwbGFjZV9BWlZQTlJvb3RDQTAeFw0yMzEx
MTUxMzQ3NTZaFw00MzExMTUxMzU3NTZaMCgxJjAkBgNVBAMMHUJVTU9ERVJOV29y
a3BsYWNlX0FaVlBOUm9vdENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEA4WXvYQy/RDiy0psssjpDg22F0fCFJzajLu4dFl6FZ2xOO87VqzF/me+z5uCC
+weWti9lxdl/e6pn3lF3D1rhJil7VqL9r8cGNBASLHJx4Sax6a7p2AM84x0CqPcu
BeJiJhy0uueVRuLxBuTPETJ99CXafBreLAnp3+9yTxgYy4V6L9urSqZmbnIRothM
lvy9QEvm6BMDhTtFmQ/6dmo/qw5DWLbO/piuvHes3ATvIy+xmy1xXMg7HBLdv4lu
NCt7wuhe3vqzdDfnJUDKNyeLnpDMdBSuosS/enc7gk7D3l0OYroKc2Qa1WscWDx8
t9Bv6wNOmqSF3z9+EFK8IirwWQIDAQABozEwLzAOBgNVHQ8BAf8EBAMCAgQwHQYD
VR0OBBYEFGym3v53PX5h59OjGfpRctOZM/sdMA0GCSqGSIb3DQEBCwUAA4IBAQBd
TvKUyNn3D66JrEYr/JKLZ4yD0wx3eTxnQiLsWbgBehX3TEdhDRXfV4Jizs4oB3+h
HkRTHl7QGbOoJ6XnOxyCBKLu+p9EDPvSgMIC5gqFnS9w+j7o5gDlxTogRjjT3eVP
f3cRsMZdu4NG9PHidQSGjRDgPw+RD17qpOQVFzPNJ/ttJLvrIY3+pbsSjq5Eu09Y
MGjFUN7k+kbPWi0LHyGGb05FSvJo1r6d5tYj/r8+MdZyGkuLesi5VHs0P3ATbcR5
bZ4O/U79v7NFmvtG7/W8XnyKbKGOk0ooDllDJJLUjhI1Fij5By47TS4ASkz8UPkg
PJeX+Pe2oSjsFAkRD44B
EOF
    }

  }

  timeouts {
    create = "120m"
  }
  depends_on          = [azurerm_subnet.vpnsubnet]
}

/* Creation of the Recovery Services Vault */

resource "azurerm_recovery_services_vault" "vault" {
  name                = "${var.resource_group_name}-BackupVault"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.vault_sku
  soft_delete_enabled = var.soft_delete_enabled
  depends_on          = [azurerm_resource_group.rg]
}

/* Creation of the Backup Policy */

resource "azurerm_backup_policy_vm" "AzureBackupPolicy" {
  name                           = var.backup_policy_name
  resource_group_name            = azurerm_resource_group.rg.name
  recovery_vault_name            = "${var.resource_group_name}-BackupVault"
  policy_type                    = var.policy_type
  timezone                       = var.timezone
  instant_restore_retention_days = var.instant_restore_retention_days

  backup {
    frequency = var.backup_frequency
    time      = var.backup_time
  }

  retention_daily {
    count = var.daily_count
  }

  dynamic "retention_weekly" {
    for_each = var.weekly_count == 0 ? [] : [1]
    content {
      count    = var.weekly_count
      weekdays = var.weekly_weekdays
    }

  }

  dynamic "retention_monthly" {
    for_each = var.monthly_count == 0 ? [] : [1]
    content {
      count    = var.monthly_count
      weekdays = var.monthly_weekdays
      weeks    = var.monthly_weeks
    }

  }
  dynamic "retention_yearly" {
    for_each = var.yearly_count == 0 ? [] : [1]
    content {
      count    = var.yearly_count
      weekdays = var.yearly_weekdays
      weeks    = var.yearly_weeks
      months   = var.yearly_months
    }

  }
  depends_on          = [azurerm_recovery_services_vault.vault]
}

/* Assign Backup Policy to our VM */

resource "azurerm_backup_protected_vm" "protected_vm" {
  for_each = var.vm_map

  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = "${var.resource_group_name}-BackupVault"
  backup_policy_id    = azurerm_backup_policy_vm.AzureBackupPolicy.id
  source_vm_id        = azurerm_windows_virtual_machine.vm[each.key].id
  depends_on          = [azurerm_backup_policy_vm.AzureBackupPolicy]
}