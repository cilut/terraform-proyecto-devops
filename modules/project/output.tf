output "p_project_id" {
  value = azuredevops_project.project.id
}

output "sc_id" {
  value = azuredevops_serviceendpoint_azurerm.service_connection[0].id
}
