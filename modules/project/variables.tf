
variable "p_project_name" {
  type = string
  default = ""
}

variable "p_connection_service" {
  type = list(object({
    p_service_endpoint_name = string
    p_description           = string
    p_serviceprincipalid  = string
    p_serviceprincipalkey = string
    p_azurerm_spn_tenantid      = string
    p_azurerm_subscription_id   = string
    p_azurerm_subscription_name = string

  }))
}
