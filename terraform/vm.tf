resource "azurerm_public_ip" "vm" {
  name                = "pip-mysql-vm"
  location            = azurerm_resource_group.rg-azure-mysql-vm.location
  resource_group_name = azurerm_resource_group.rg-azure-mysql-vm.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_network_interface" "vm" {
  name                = "nic-mysql-vm"
  location            = azurerm_resource_group.rg-azure-mysql-vm.location
  resource_group_name = azurerm_resource_group.rg-azure-mysql-vm.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }
}
resource "azurerm_linux_virtual_machine" "vm-mysql-app" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg-azure-mysql-vm.name
  location            = azurerm_resource_group.rg-azure-mysql-vm.location
  size                = "Standard_B1s"

  admin_username = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.vm.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(
    templatefile("${path.module}/cloud-init.yaml", {
      mysql_host     = azurerm_mysql_flexible_server.mysql.fqdn
      mysql_database = var.mysql_database_name
      mysql_user     = var.mysql_admin_username
      mysql_password = var.mysql_admin_password
    })
  )

  depends_on = [
    azurerm_mysql_flexible_server.mysql
  ]
}
