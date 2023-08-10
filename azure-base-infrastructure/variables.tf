variable "resource_group_name" {
    type = string
    description = "resource group name of the virtual network"
}

variable "location" {
    type = string
    description = "location of the virtual network"
}

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