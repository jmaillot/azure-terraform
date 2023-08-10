
resource "azurerm_public_ip" "ippub" {
  name                = "${var.vpn_gateway_name}-IP"
  resource_group_name = var.resource_group_name
  location            = var.location
 
  allocation_method = "Dynamic"

}

resource "azurerm_subnet" "vpnsubnet" {
    name                      = "GatewaySubnet"
    resource_group_name       = var.resource_group_name
    virtual_network_name      = var.virtual_network_name
    address_prefixes          = var.vpn_subnet_address_prefixes
}

resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = var.vpn_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location

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
      name = "VPNROOTCA"
      public_cert_data = <<EOF
MIIC4zCCAcugAwIBAgIQNxE55rUVb71NB/tUS57hszANBgkqhkiG9w0BAQsFADAU
MRIwEAYDVQQDDAlWUE5ST09UQ0EwHhcNMjMwODEwMDc1NDE1WhcNNDMwODEwMDgw
NDE0WjAUMRIwEAYDVQQDDAlWUE5ST09UQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDAQ3GMTN6Qw7mkG5nB+J8IS7zRzTny3EO4d6y9qboY72ModkdZ
RwnJejxZhKkExhItYriOO2OOXrodYnX9P2DWtG5CNCUdgduWC5nDXEwgXx9QeaH8
b+rk8VxXf/iIE5ASGYKDQb/qieU2apTRo6jjq/1l3Gh4NJWvnmLCgMU3wrpxNz9m
0yLZCXuQ10QylBE/Vx+7e4RZMJ/a7Aam6RIa5MbSoXu85xzeZBj42PKRKtQi1MB6
jv919Ddz/FYMBHLoVkugo0z6by9qYAnbIG8UaNYUUc36djNTmhM/kxTNVilLi/2F
6dYNTF3i3ltLFaxrPfCegbukWB0JUJDtRDe5AgMBAAGjMTAvMA4GA1UdDwEB/wQE
AwICBDAdBgNVHQ4EFgQUhzDVd5Av//unqJbv5Cg3hjVcbOUwDQYJKoZIhvcNAQEL
BQADggEBAGZKWpla7c7ZFcdhAu8X2zJzTXikdZkF1H5Zdddkivo+MgeDO85qmmfU
TKI62saGUE4gZTtcy6Fd4wFMyNIvwar1Lf6xAu5qpu5yGGNthX8QORKNjmbcRj+v
Rvl8xSVfo2LjM8vvjxGybWQqTmEPzmnq0AtvsfVXiWBVKouzvyb7VPUZMeeL5tBn
PSxrbRa86t20wDnxgtUP2/+d+56WeUtL86seEziPBFVXCQpsnH8qCj1p27/Crglh
xlTwAt8biP9mtxVCIm5Tct+kiRSIfpLm42QMtqsvEPex9I4VJ51/CmP7J7npADJr
gXQk/TEwX8eRYg4/RHJNN64LVZkYpms=
EOF
    }

  }

  timeouts {
    create = "120m"
  }
}
