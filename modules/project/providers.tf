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
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.61.0"
    }
  }
}

# Configure the Azure Active Directory Provider
provider "azuread" {
  tenant_id = var.p_connection_service[0].p_azurerm_spn_tenantid
}

# Provider Block
provider "azurerm" {
  features {}
}

