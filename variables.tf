variable "azdo_org_service_url" {
  type = string
}

variable "azdo_personal_access_token" {
  type = string
  default = ""
  sensitive = true
}

variable "project_name" {
  type = string
  default = ""
}

variable "organization_name" {
  type = string
  default = ""
}

variable "connection_service" {
  type = list(object({
    p_service_endpoint_name = string
    p_description           = string
    p_serviceprincipalid  = string
    p_serviceprincipalkey = string
    p_azurerm_spn_tenantid      = string
    p_azurerm_subscription_id   = string
    p_azurerm_subscription_name = string

  }))
  sensitive = true
}



variable "repositories" {
  type = list(object({
    rp_repository_name   = string
  }))
}

variable "build_pipelines" {
  type = list(object({
    bp_name              = string
    bp_repository_name   = string
    bp_path              = string
    bp_fichero_yml       = string
  }))
}

variable "release_pipelines" {
  type = list(object({
    rp_name              = string
    rp_repository_name   = string
  }))
}


