#################################
# Azure RG & Location Variables #
#################################

variable "resource_group_name" {
    type = string
    description = "The name of resource group"
}

variable "location" {
    type = string
    description = "Azure location "
}

#####################################
# Azure Network Interface Variables #
#####################################

variable "network_interface_ids" {
    type = string
    description = "network interface id"
}

###################################
# Azure Virtual Machine Variables #
###################################

variable "vmname" {
    type = string
    description = "The name of the virtual machine"
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
}

variable "admin_password" {
    type = string
    description = "password of the local admin user"
}

variable "image_publisher" {
    type = string
    description = "Azure image publisher"
}

variable "image_offer" {
    type = string
    description = "Azure image offer"
}

variable "image_sku" {
    type = string
    description = "Azure image sku"
}

variable "vm_id" {
  type        = string
  description = "Azure Virtual Machine ID"
}