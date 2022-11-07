
# Azure integration for metrics & monitoring
resource "datadog_integration_azure" "azure-integration" {
  tenant_name   = var.azure_tenant_id
  client_id     = var.azure_client_id
  client_secret = var.azure_client_secret
}

# Set up logging
# c.f https://docs.datadoghq.com/integrations/azure/?tab=automatedinstallation#setup

resource "azurerm_resource_group" "datadog-logs-rg" {
  name     = "datadog-azure-logs"
  location = "East US"
}

data "http" "arm-template" {
  url = "https://raw.githubusercontent.com/DataDog/datadog-serverless-functions/master/azure/deploy-to-azure/parent_template.json"
}
resource "azurerm_resource_group_template_deployment" "datadog-logs" {
  name                = "datadog-azure-logs"
  resource_group_name = azurerm_resource_group.datadog-logs-rg.name
  deployment_mode     = "Incremental"
  template_content    = data.http.arm-template.response_body
  parameters_content = jsonencode({
    "sendActivityLogs" = {
      value = true
    },
    "apiKey" = {
      value = var.ddApiKey
    }
  })
}
