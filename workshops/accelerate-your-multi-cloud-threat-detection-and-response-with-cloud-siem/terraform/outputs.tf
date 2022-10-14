output "app_url" {
  value = format("http://${azurerm_container_group.app.fqdn}:8000")
}
