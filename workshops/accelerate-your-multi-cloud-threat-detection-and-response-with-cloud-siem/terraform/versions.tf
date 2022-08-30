
terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.20.0"
    }
  }
}
