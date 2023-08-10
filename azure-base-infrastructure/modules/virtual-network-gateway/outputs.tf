output "virtual_network_gateway_id" {
  value = azurerm_virtual_network_gateway.vpngw.id
}

output "vpngw_name" {
  value = azurerm_virtual_network_gateway.vpngw.name
}

output "vpn_subnet_addr_prefixes" {
  value = var.vpn_subnet_address_prefixes
}