

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
    name   = "datadog-agent"
    image  = "datadog/agent:latest"
    cpu    = "0.5"
    memory = "2"

    environment_variables = {
      "DD_API_KEY"     = var.ddApiKey,
      "DD_APM_ENABLED" = "true",
    }
  }

  container {
    name   = "app"
    image  = "ghcr.io/datadog/vulnerable-java-application:latest"
    cpu    = "0.5"
    memory = "2"

    environment_variables = {
      "DD_TRACE_AGENT_URL"   = "127.0.0.1:8126",
      "DD_ENV"               = "production",
      "DD_SERVICE"           = "domain-tester-service",
      "DD_VERSION"           = "1.0",
      "DD_PROFILING_ENABLED" = "true"
      "DD_TRACE_SAMPLE_RATE" = "1",
      "DD_APPSEC_ENABLED"    = "true"
    }

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

  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_subscription" "subscription" {}

resource "azurerm_role_assignment" "app" {
  scope                = data.azurerm_subscription.subscription.id
  role_definition_name = "Disk Snapshot Contributor"
  principal_id         = azurerm_container_group.app.identity[0].principal_id
}




