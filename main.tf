terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. Erőforráscsoport (Resource Group)
resource "azurerm_resource_group" "rg" {
  name     = "rg-vpn-lab-northeurope"
  location = "North Europe"
}

# 2. Virtuális Hálózat (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-hub-corp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.100.0.0/16"]
}

# 3. Gateway Subnet (Az Azure VPN Gateway kizárólag ebbe a pontos nevű alhálózatba telepíthető)
resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.100.255.0/27"]
}

# 4. Nyilvános IP-cím a VPN Gateway számára
resource "azurerm_public_ip" "vpngw_pip" {
  name                = "pip-vpngw-hub"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 5. Útvonalalapú (RouteBased) VPN Gateway (Zónaredundáns SKU)
resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = "vpngw-hub-corp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  sku           = "VpnGw1AZ" # Frissítve zónaredundáns SKU-ra

  ip_configuration {
    name                          = "vpngw-config"
    public_ip_address_id          = azurerm_public_ip.vpngw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
}