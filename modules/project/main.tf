
resource "azuredevops_project" "project" {

  #name               = var.p_project_name
  name               = var.general.project_name
  description        = "This is an example project"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"

}

resource "azuredevops_group" "example" {
  scope        = azuredevops_project.project.id
  display_name = "Example group"
  description  = "Example description"


}

resource "azuredevops_team" "teams" {
  count = length(var.teams)

  project_id = azuredevops_project.project.id
  name       = var.teams[count.index].name
  administrators = [
    azuredevops_group.example.descriptor
  ]
  members = [
    azuredevops_group.example.descriptor
  ]

}


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


# Variable to store your Area Path details
variable "area_path" {
  default = {
    name = "Area1"
  }
}

# # Create the Area Path using Azure DevOps REST API
# resource "null_resource" "create_area_path" {
#   depends_on = [azuredevops_project.project, azuredevops_team.teams]
#   for_each   = { for team in var.teams : team.name => team }

#   provisioner "local-exec" {
#     interpreter = ["PowerShell", "-Command"]
#     command     = <<-EOT
#       Invoke-WebRequest -Uri "https://dev.azure.com/${var.p_organization_name}/${var.p_project_name}/_apis/wit/classificationnodes/areas?api-version=6.0" `
#       -Method Post `
#       -ContentType "application/json" `
#       -Headers @{Authorization=("Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "", "${var.p_azdo_personal_access_token}"))))} `
#       -Body ('{"name": "${each.value.name}"}') `
#     EOT
#   }
# }

resource "null_resource" "install_devops_extention" {
  depends_on = [azuredevops_project.project, azuredevops_team.teams]
  for_each   = { for team in var.teams : team.name => team }

  provisioner "local-exec" {

    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT
      az config set extension.use_dynamic_install=yes_without_prompt 
    EOT
  }
}


resource "null_resource" "create_area_path" {
  depends_on = [azuredevops_project.project, azuredevops_team.teams]
  for_each   = { for team in var.teams : team.name => team }

  provisioner "local-exec" {

    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT
      az boards area project delete --path '\${var.general.project_name}\Area\${each.value.name}' --project '${var.general.project_name}' --yes
      
      az boards area project create --name '${each.value.name}' --path '\${var.general.project_name}\Area\' --project '${var.general.project_name}' 
      
    EOT
  }
  # triggers = {
  #   always_run = "${timestamp()}"
  # }
}

resource "null_resource" "associate_area_path" {
  depends_on = [null_resource.create_area_path, azuredevops_team.teams, azuredevops_project.project]
  for_each   = { for team in var.teams : team.name => team }
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT
      az boards area team add --team '${each.value.name}' --path '\${var.general.project_name}\${each.value.name}' --set-as-default --include-sub-areas true --project ${azuredevops_project.project.id}
    EOT
  }
  # triggers = {
  #   always_run = "${timestamp()}"
  # }
}

data "azuredevops_iteration" "iteration" {
  project_id     = azuredevops_project.project.id
  path           = "/"
  fetch_children = true
}

resource "null_resource" "associate_iteration_path" {
  depends_on = [null_resource.create_area_path, azuredevops_team.teams, azuredevops_project.project]
  for_each   = { for team in var.teams : team.name => team }
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT
      az boards iteration team set-backlog-iteration --id ${data.azuredevops_iteration.iteration.id} --team '${each.value.name}' --project ${azuredevops_project.project.id}
    EOT
  }
  #   triggers = {
  #     always_run = "${timestamp()}"
  #   }
}

resource "null_resource" "associate_iteration_path_1" {
  depends_on = [null_resource.create_area_path, azuredevops_team.teams, azuredevops_project.project]
  for_each   = { for team in var.teams : team.name => team }
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT
      $childrenJson = '${jsonencode(data.azuredevops_iteration.iteration.children)}'
      $children = $childrenJson | ConvertFrom-Json
      foreach ($child in $children) {
        az boards iteration team add --id $child.id --team '${each.value.name}' --project ${azuredevops_project.project.id}
      }
    EOT
  }
  # triggers = {
  #   always_run = "${timestamp()}"
  # }
}
