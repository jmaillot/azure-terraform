#################################
# Azure RG & Location Variables #
#################################

variable "location" {
    type = string
    description = "Azure location"
}

variable "resource_group_name" {
    type = string
    description = "name of the resource group"
}

###################################
# Azure Virtual Machine Variables #
###################################

variable "vmname" {
    type = string
    description = "name of the vm"
}

