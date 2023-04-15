# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = "0.4.0"
    }   
    external = {
      source = "hashicorp/external"
      version = ">= 2.0"
    }     
  }


}
