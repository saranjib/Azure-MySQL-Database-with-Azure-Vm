variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-azure-mysql-vm"
}

variable "vnet_name" {
  description = "Virtual network name"
  type        = string
  default     = "vnet-mysql-vm"
}

variable "vm_name" {
  description = "Linux VM name"
  type        = string
  default     = "vm-mysql-app"
}

variable "admin_username" {
  description = "VM admin username"
  type        = string
  default     = "azureadmin"
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
  sensitive   = true
}

variable "mysql_admin_username" {
  description = "MySQL administrator username"
  type        = string
  default     = "mysqladmin"
}

variable "mysql_admin_password" {
  description = "MySQL administrator password"
  type        = string
  sensitive   = true
}

variable "mysql_database_name" {
  description = "Application database name"
  type        = string
  default     = "inventorydb"
}
