terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "3.14.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.20.0"
    }
  }
}
