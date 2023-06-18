# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.39.0"
    }
  }
}

# Configure the Azure Active Directory Provider
provider "azuread" {
  tenant_id = "1dc5f082-bdf6-41d2-8ddd-70b99ad58b99"
}

