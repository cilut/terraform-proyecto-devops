variable "general" {
  type = map(string)
  default = {
    project_name               = ""
    organization_name          = ""
    azdo_org_service_url       = ""
    azdo_personal_access_token = ""
  }
}
#variable "p_project_name" {
#  type    = string
#  default = ""
#}
#variable "p_organization_name" {
#  type    = string
#  default = ""
#}
#variable "p_azdo_personal_access_token" {
#  type    = string
#  default = ""
#}

variable "p_connection_service" {
  type = list(object({
    p_service_endpoint_name     = string
    p_description               = string
    p_serviceprincipalid        = string
    p_serviceprincipalkey       = string
    p_azurerm_spn_tenantid      = string
    p_azurerm_subscription_id   = string
    p_azurerm_subscription_name = string

  }))
}

variable "teams" {
  type = list(object({
    name        = string
    description = string
  }))
}
