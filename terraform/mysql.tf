resource "azurerm_private_dns_zone" "mysql" {
  name                = "private.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg-azure-mysql-vm.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "mysql-dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = azurerm_virtual_network.vnet-mysql-vm.id
  resource_group_name   = azurerm_resource_group.rg-azure-mysql-vm.name
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "mysqlvmproject2026"
  resource_group_name    = azurerm_resource_group.rg-azure-mysql-vm.name
  location               = azurerm_resource_group.rg-azure-mysql-vm.location

  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password

  version = "8.0.21"

  delegated_subnet_id = azurerm_subnet.mysql.id
  private_dns_zone_id = azurerm_private_dns_zone.mysql.id

  sku_name = "B_Standard_B1ms"

  storage {
    size_gb = 20
  }

  backup_retention_days = 7

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.mysql
  ]
}

resource "azurerm_mysql_flexible_database" "app" {
  name                = var.mysql_database_name
  resource_group_name = azurerm_resource_group.rg-azure-mysql-vm.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8mb4"
  collation            = "utf8mb4_unicode_ci"
}
