provider "azurerm" {
  features {}
}

provider "azuredevops" {
  organization = var.azuredevops_organization_url
  access_token = var.azuredevops_personal_access_token
}
