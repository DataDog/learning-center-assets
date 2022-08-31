resource "azurerm_resource_group" "backups" {
  name     = "rg-backups"
  location = "West US"
}

resource "azurerm_managed_disk" "disk" {
  count                = 3
  name                 = "backups_v${count.index}"
  location             = azurerm_resource_group.backups.location
  resource_group_name  = azurerm_resource_group.backups.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
}

output "disk_names" {
  value = azurerm_managed_disk.disk[*].name
}
