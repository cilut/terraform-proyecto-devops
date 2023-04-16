
resource "azuredevops_project" "project" {

  name = var.p_project_name
  description = "This is an example project"
  visibility = "private"

}


# resource "azuredevops_serviceendpoint_azurerm" "service_connection" {
#   project_id                = azuredevops_project.project.id
#   service_endpoint_name     = "GeneralConnection"
#   description               = "Service connection for an Azure subscription"
#   client_secret             = "mJv8Q~H4tC~9EOOPumXy64l9ofNMYuUSfdIBIc4C"
#   subscription_id           = "d0ff7b71-9926-4d0f-b630-4c832323cab4"
#   tenant_id                 = "3562aa71-b864-4155-9bbf-9dc4d88853dd"
# }

# resource "azuredevops_serviceendpoint_azurerm" "example" {
#   project_id                = azuredevops_project.project.id
#   service_endpoint_name     = "GeneralConnection"
#   azurerm_spn_tenantid      = "3562aa71-b864-4155-9bbf-9dc4d88853dd"
#   azurerm_subscription_id   = "d0ff7b71-9926-4d0f-b630-4c832323cab4"
#   azurerm_subscription_name = "ServiciosGratuitos_Revisar"
# }



resource "azuredevops_serviceendpoint_azurerm" "service_connection" {
  count = length(var.p_connection_service)

  
  project_id            = azuredevops_project.project.id
  service_endpoint_name = var.p_connection_service[count.index].p_service_endpoint_name
  description           = var.p_connection_service[count.index].p_description
  credentials {
    serviceprincipalid  = var.p_connection_service[count.index].p_serviceprincipalid
    serviceprincipalkey = var.p_connection_service[count.index].p_serviceprincipalkey
  }
  azurerm_spn_tenantid      = var.p_connection_service[count.index].p_azurerm_spn_tenantid 
  azurerm_subscription_id   = var.p_connection_service[count.index].p_azurerm_subscription_id
  azurerm_subscription_name = var.p_connection_service[count.index].p_azurerm_subscription_name
  
}