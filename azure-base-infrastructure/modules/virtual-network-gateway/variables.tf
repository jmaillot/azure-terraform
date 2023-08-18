#################################
# Azure RG & Location Variables #
#################################

variable "resource_group_name" {
    type = string
    description = "name of the resource group"
}

variable "location" {
    type = string
    description = "Azure location"
}

###################################
# Azure Virtual Network Variables #
###################################

variable "virtual_network_name" {
    type = string
    description = "name of the virtual network"
}

###########################################
# Azure Virtual Network Gateway Variables #
###########################################

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