

resource "azurerm_resource_group" "app" {
  name     = "vulnerable-java-app"
  location = "East US"
}

resource "random_string" "random" {
  length    = 16
  min_lower = 16
}


resource "azurerm_container_group" "app" {
  name                = "vulnerable-java-app"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  dns_name_label      = "domain-tester-service-${random_string.random.result}"
  ip_address_type     = "Public"
  os_type             = "Linux"

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
aws_secret_access=${aws_iam_access_key.vulnerableapp.secret}
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
