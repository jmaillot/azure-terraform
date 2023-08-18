#################################
# Azure RG & Location Variables #
#################################

variable "resource_group_name" {
    type = string
    description = "resource group name"
}

variable "location" {
    type = string
    description = "location of the resources"
}

###################################
# Azure Virtual Network Variables #
###################################

variable "virtual_network_name" {
    type = string
    description = "name of the virtual network"
}

variable "virtual_network_address_space" {
    type = list(string)
    description = "address space of the virtual network"
}

variable "subnet_name" {
    type = string
    description = "name of the subnet"
}

variable "subnet_address_prefixes" {
    type = list(string)
    description = "address prefix of the subnet"
}

###################################
# Azure Virtual Machine Variables #
###################################

variable "vmname" {
    type = string
    description = "name of the vm"
}

variable "vm_size" {
    type = string
    description = "size of the virtual machine"
}

variable "os_disk_type" {
    type = string
    description = "type of the os disk. example Standard_LRS"
}

variable "admin_username" {
    type = string
    description = "local admin user of the virtual machine"
    default = "admin.prodware"
}

variable "image_publisher" {
    type = string
    description = "Azure image publisher"
    default = "MicrosoftWindowsServer"
}

variable "image_offer" {
    type = string
    description = "Azure image offer"
    default = "WindowsServer"
}

variable "image_sku" {
    type = string
    description = "Azure image sku"
    default = "2022-Datacenter"
}

variable "virtual_machine_network_interface_ip" {
  type        = string
  description = "Azure Virtual Machine Private IP"
}

###############################
# Azure VPN Gateway Variables #
###############################

variable "vpn_gateway_name" {
    type = string
    description = "name of the virtual network gateway"
}

variable "vpn_gateway_sku" {
    type = string
    description = "sku of the virtual network gateway"
}

variable "vpn_subnet_address_prefixes" {
    type = list(string)
    description = "address prefix of the subnet"
}

variable "vpn_client_subnet_address_prefixes" {
    type = list(string)
    description = "address prefix of the vpn client subnet"
}

##########################
# Azure Backup Variables #
##########################

variable "backup_policy_name" {
  type        = string
  description = "The name of the backup policy."
}

variable "vault_sku" {
    type = string
    description = "Sku of the Recovery Services vault"
    default = "Standard"
}

variable "policy_type" {
  type        = string
  description = "The type of the backup policy."
  default     = "V1"
}

variable "timezone" {
  type        = string
  description = "The timezone of the backup policy."
  default     = "Romance Standard Time"
}

variable "instant_restore_retention_days" {
  type        = number
  description = "The number of days to retain instant restore points."
  default     = 2
}

variable "backup_frequency" {
  type        = string
  description = "The frequency of the backup."
  default     = "Daily"
}

variable "backup_time" {
  type        = string
  description = "The time of day to perform the backup."
  default     = "19:00"
}

variable "daily_count" {
  type        = number
  description = "The number of daily backups to retain."
  default     = 7
}

variable "weekly_count" {
  type        = number
  description = "The number of weekly backups to retain."
  default     = 4
}

variable "weekly_weekdays" {
  type        = list(string)
  description = "The weekdays on which to perform weekly backups."
  default     = ["Friday"]
}

variable "monthly_count" {
  type        = number
  description = "The number of monthly backups to retain."
  default     = 12
}

variable "monthly_weekdays" {
  type        = list(string)
  description = "The weekdays on which to perform monthly backups."
  default     = ["Friday"]
}

variable "monthly_weeks" {
  type        = list(string)
  description = "The weeks of the month on which to perform monthly backups."
  default     = ["Last"]
}

variable "yearly_count" {
  type        = number
  description = "The number of yearly backups to retain."
  default     = 10
}

variable "yearly_weekdays" {
  type        = list(string)
  description = "The weekdays on which to perform yearly backups."
  default     = ["Friday"]
}

variable "yearly_weeks" {
  type        = list(string)
  description = "The weeks of the year on which to perform yearly backups."
  default     = ["Last"]
}

variable "yearly_months" {
  type        = list(string)
  description = "The months of the year on which to perform yearly backups."
  default     = ["December"]
}