
resource "azuredevops_project" "project" {

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

# Create an application
resource "azuread_application" "application" {
  display_name = "ExampleApp"
}

resource "azuread_application_password" "app_secret" {
  application_object_id = azuread_application.application.object_id

}

data "azurerm_subscription" "primary" {
}

# data "azurerm_client_config" "example" {
# }

resource "azuread_service_principal" "service_principal" {
  application_id               = azuread_application.application.application_id
  app_role_assignment_required = false
}

resource "azurerm_role_assignment" "example" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.service_principal.object_id
}

resource "azuredevops_serviceendpoint_azurerm" "service_connection" {
  count = length(var.p_connection_service)


  project_id            = azuredevops_project.project.id
  service_endpoint_name = var.p_connection_service[count.index].p_service_endpoint_name
  description           = var.p_connection_service[count.index].p_description
  credentials {
    serviceprincipalid  = azuread_application.application.application_id
    serviceprincipalkey = azuread_application_password.app_secret.value
  }
  azurerm_spn_tenantid      = var.p_connection_service[count.index].p_azurerm_spn_tenantid
  azurerm_subscription_id   = var.p_connection_service[count.index].p_azurerm_subscription_id
  azurerm_subscription_name = var.p_connection_service[count.index].p_azurerm_subscription_name

}

resource "azuredevops_resource_authorization" "example" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_azurerm.service_connection[0].id
  authorized  = true
}


# Variable to store your Area Path details
variable "area_path" {
  default = {
    name = "Area1"
  }
}


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
      #az boards area project delete --path '\${var.general.project_name}\Area\${each.value.name}' --project '${var.general.project_name}' --yes
      
      az boards area project create --name '${each.value.name}' --organization 'https://dev.azure.com/${var.general.organization_name}/'--path '\${var.general.project_name}\Area\' --project '${var.general.project_name}' 
      
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
      az boards area team add --team '${each.value.name}' --organization 'https://dev.azure.com/${var.general.organization_name}/' --path '\${var.general.project_name}\${each.value.name}' --set-as-default --include-sub-areas true --project ${azuredevops_project.project.id}
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
      az boards iteration team set-backlog-iteration --id ${data.azuredevops_iteration.iteration.id} --organization 'https://dev.azure.com/${var.general.organization_name}/' --team '${each.value.name}' --project ${azuredevops_project.project.id}
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
        az boards iteration team add --id $child.id --team '${each.value.name}' --organization 'https://dev.azure.com/${var.general.organization_name}/' --project ${azuredevops_project.project.id}
      }
    EOT
  }
  # triggers = {
  #   always_run = "${timestamp()}"
  # }
}
