provider "azurerm" {
  features {
    resource_group {
      # Automatically remove resources in a resource group when it's destroyed
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "aws" {

}
