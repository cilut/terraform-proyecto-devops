# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.4.0"
    }
  }
}


provider "azuredevops" {
  org_service_url       = var.general.azdo_org_service_url
  personal_access_token = var.general.azdo_personal_access_token
}
