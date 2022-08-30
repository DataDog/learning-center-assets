
variable "azure_tenant_id" {}
variable "azure_client_id" {}
variable "azure_client_secret" {}

resource "datadog_integration_azure" "azure-integration" {
  tenant_name   = var.azure_tenant_id
  client_id     = var.azure_client_id
  client_secret = var.azure_client_secret
}
