output "resource_group_name" {
  value = azurerm_resource_group.rg-azure-mysql-vm.name
}

output "vm_public_ip" {
  value = azurerm_public_ip.vm.ip_address
}

output "vm_private_ip" {
  value = azurerm_network_interface.vm.private_ip_address
}

output "mysql_server_fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "application_url" {
  value = "http://${azurerm_public_ip.vm.ip_address}"
}
