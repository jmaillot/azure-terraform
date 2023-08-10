variable "vmname" {
    type = string
    description = "name of the vm"
}

variable "location" {
    type = string
    description = "Azure location"
}

variable "resource_group_name" {
    type = string
    description = "name of the resource group"
}

variable "subnet_id" {
    type = string
    description = "id of the subnet"
}

variable "network_security_group_id" {
    type = string
    description = "network security group"
}

variable "virtual_machine_network_interface_ip" {
  type        = string
  description = "Azure Virtual Machine Private IP"
}
