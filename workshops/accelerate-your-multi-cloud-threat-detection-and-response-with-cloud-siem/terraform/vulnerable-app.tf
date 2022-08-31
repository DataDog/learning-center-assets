

resource "azurerm_resource_group" "app" {
  name     = "vulnerable-java-app"
  location = "East US"
}

resource "random_string" "random" {
  length    = 16
  min_lower = 16
}


# resource "azurerm_log_analytics_workspace" "applogs" {
#   name                = "vulnerable-app-logs"
#   location            = azurerm_resource_group.app.location
#   resource_group_name = azurerm_resource_group.app.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30 # minimum
# }


resource "azurerm_container_group" "app" {
  name                = "vulnerable-java-app"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  dns_name_label      = "domain-tester-service-${random_string.random.result}"
  ip_address_type     = "Public"
  os_type             = "Linux"

  # diagnostics {
  #   log_analytics {
  #     log_type      = "ContainerInstanceLogs"
  #     workspace_id  = azurerm_log_analytics_workspace.applogs.workspace_id
  #     workspace_key = azurerm_log_analytics_workspace.applogs.primary_shared_key
  #   }
  # }

  container {
    name   = "app"
    image  = "ghcr.io/datadog/vulnerable-java-application:latest"
    cpu    = "0.5"
    memory = "2"

    ports {
      port     = 8000
      protocol = "TCP"
    }

    volume {
      name       = "aws-creds"
      mount_path = "/root/.aws"
      read_only  = true
      secret = {
        "credentials" = base64encode(<<EOT
[default]
aws_access_key_id=${aws_iam_access_key.vulnerableapp.id}
aws_secret_access_key=${aws_iam_access_key.vulnerableapp.secret}
EOT
      ) }
    }

    readiness_probe {
      initial_delay_seconds = 10
      http_get {
        path   = "/"
        port   = 8000
        scheme = "Http"
      }
    }
  }
}
