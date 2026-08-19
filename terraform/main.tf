resource "azurerm_resource_group" "rg-azure-mysql-vm" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet-mysql-vm" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg-azure-mysql-vm.location
  resource_group_name = azurerm_resource_group.rg-azure-mysql-vm.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "app" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.rg-azure-mysql-vm.name
  virtual_network_name = azurerm_virtual_network.vnet-mysql-vm.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "mysql" {
  name                 = "mysql-subnet"
  resource_group_name  = azurerm_resource_group.rg-azure-mysql-vm.name
  virtual_network_name = azurerm_virtual_network.vnet-mysql-vm.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "mysql-delegation"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}
