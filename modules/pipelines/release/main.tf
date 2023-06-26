resource "azuredevops_variable_group" "vg_infra_pipeline" {
  count = length(var.release_pipeline_variables_groups)

  project_id   = var.project_id
  name         = var.release_pipeline_variables_groups[count.index].name
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "location"
    value = var.release_pipeline_variables_groups[count.index].location
  }

  variable {
    name  = "terraformstoragerg"
    value = var.release_pipeline_variables_groups[count.index].terraformstoragerg
  }

  variable {
    name  = "terraformstorageaccount"
    value = var.release_pipeline_variables_groups[count.index].terraformstorageaccount
  }

  variable {
    name  = "terraformcontainer"
    value = var.release_pipeline_variables_groups[count.index].terraformcontainer
  }

  variable {
    name  = "sku"
    value = var.release_pipeline_variables_groups[count.index].sku
  }

  variable {
    name  = "env"
    value = var.release_pipeline_variables_groups[count.index].name
  }
}


resource "null_resource" "import_task_group_json" {

  provisioner "local-exec" {

    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT

      $token = "${var.general.azdo_personal_access_token}"
      $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($token)"))
      $headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}  

      $url_repo = "https://dev.azure.com/${var.general.organization_name}/${var.general.project_name}/_apis/git/repositories?api-version=6.0"
      $responseRepo = Invoke-RestMethod -Uri $url_repo -Headers $headers -ContentType application/json
      $repo = $responseRepo.value | Where-Object { $_.name -eq "${var.release_pipeline_variables.repo_infra_name}" }

      $url_agent = "https://dev.azure.com/${var.general.organization_name}/${var.general.project_name}/_apis/distributedtask/queues?api-version=7.0"
      $responseAgent = Invoke-RestMethod -Uri $url_agent -Headers $headers -Method Get
      $agentPool = $responseAgent.value | Where-Object { $_.name -eq "Azure Pipelines" }    

      $taskGroup = Get-Content -Path "${path.module}${local.json_data[0].task_group_path}" -Raw
      $taskGroup_mod = $taskGroup | ConvertFrom-Json

      $taskGroup_mod.tasks[0].inputs.connectedServiceNameARM = "${var.sc_id}"
      $taskGroup_mod.tasks[1].inputs.connectedServiceNameARM = "${var.sc_id}"
      $taskGroup_mod.tasks[3].inputs.environmentServiceNameAzureRM = "${var.sc_id}"
      $taskGroup_mod.tasks[3].inputs.backendServiceArm = "${var.sc_id}"
      $taskGroup_mod.tasks[4].inputs.environmentServiceNameAzureRM = "${var.sc_id}"
      $taskGroup_mod.tasks[4].inputs.backendServiceArm = "${var.sc_id}"
      $taskGroup_mod.tasks[5].inputs.environmentServiceNameAzureRM = "${var.sc_id}"
      $taskGroup_mod.tasks[5].inputs.backendServiceArm = "${var.sc_id}"

      $taskGroup = $taskGroup_mod | ConvertTo-Json -Depth 100
      $taskGroup | Set-Content -Path "${path.module}${local.json_data[0].task_group_path}"

      $url_task = "https://dev.azure.com/${var.general.organization_name}/${var.general.project_name}/_apis/distributedtask/taskgroups?api-version=7.0"
      $taskgroup = Get-Content -Raw -Path "${path.module}${local.json_data[0].task_group_path}"
      $responsetg = Invoke-RestMethod -Uri $url_task -Headers $headers -Method Post -Body $taskgroup -ContentType application/json 

      $pipeline = Get-Content -Path "${path.module}${local.json_data[0].pipeline_path}" -Raw
      $pipeline_mod = $pipeline | ConvertFrom-Json

      $pipeline_mod.environments[0].variableGroups = @(${azuredevops_variable_group.vg_infra_pipeline[0].id})
      $pipeline_mod.environments[1].variableGroups = @(${azuredevops_variable_group.vg_infra_pipeline[1].id})
      $pipeline_mod.environments[0].deployPhases[0].workflowTasks[0].taskId = $responsetg.id
      $pipeline_mod.environments[1].deployPhases[0].workflowTasks[0].taskId = $responsetg.id
      $pipeline_mod.artifacts[0].alias = "_${var.release_pipeline_variables.repo_infra_name}"
      $pipeline_mod.artifacts[0].definitionReference.project.name = "${var.general.project_name}"
      $pipeline_mod.artifacts[0].definitionReference.project.id = "${var.project_id}"
      $pipeline_mod.artifacts[0].definitionReference.definition.name = "${var.release_pipeline_variables.repo_infra_name}"
      $pipeline_mod.artifacts[0].definitionReference.definition.id = $repo.id
      $pipeline_mod.environments[0].deployPhases[0].deploymentInput.queueId = $agentPool.id
      $pipeline_mod.environments[1].deployPhases[0].deploymentInput.queueId = $agentPool.id

      $pipeline = $pipeline_mod | ConvertTo-Json -Depth 100
      $pipeline | Set-Content -Path "${path.module}${local.json_data[0].pipeline_path}"

      $url_pipeline = "https://vsrm.dev.azure.com/${var.general.organization_name}/${var.general.project_name}/_apis/release/definitions?api-version=7.0"
      $pipeline = Get-Content -Raw -Path "${path.module}${local.json_data[0].pipeline_path}"
      $response = Invoke-RestMethod -Uri $url_pipeline -Method Post -Body $pipeline -ContentType "application/json" -Headers $headers 

    EOT
  }
  # triggers = {
  #   always_run = "${timestamp()}" 
  # }
}

resource "null_resource" "api_despliegue_release" {

  provisioner "local-exec" {

    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT

      $token = "${var.general.azdo_personal_access_token}"
      $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($token)"))
      $headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

      $url_repo = "https://dev.azure.com/${var.general.organization_name}/${var.general.project_name}/_apis/git/repositories?api-version=6.0"
      $responseRepo = Invoke-RestMethod -Uri $url_repo -Headers $headers -ContentType application/json
      $repo = $responseRepo.value | Where-Object { $_.name -eq "${var.release_pipeline_variables.repo_api_name}" }

      $url_agent = "https://dev.azure.com/${var.general.organization_name}/${var.general.project_name}/_apis/distributedtask/queues?api-version=7.0"
      $responseAgent = Invoke-RestMethod -Uri $url_agent -Headers $headers -Method Get
      $agentPool = $responseAgent.value | Where-Object { $_.name -eq "Azure Pipelines" }   

      $url_build = "https://dev.azure.com/${var.general.organization_name}/${var.general.project_name}/_apis/build/definitions?api-version=7.0"
      $responseBuild = Invoke-RestMethod -Uri $url_build -Headers $headers -Method Get
      $build = $responseBuild.value | Where-Object { $_.name -eq "${var.release_pipeline_variables.pipeline_name}" }
    
      $pipeline = Get-Content -Path "${path.module}${local.json_data[1].pipeline_path}" -Raw
      $pipeline_mod = $pipeline | ConvertFrom-Json

      $pipeline_mod.environments[0].variableGroups = @(${azuredevops_variable_group.vg_infra_pipeline[0].id})
      $pipeline_mod.environments[1].variableGroups = @(${azuredevops_variable_group.vg_infra_pipeline[1].id})
      $pipeline_mod.environments[0].deployPhases[0].deploymentInput.queueId = $agentPool.id
      $pipeline_mod.environments[1].deployPhases[0].deploymentInput.queueId = $agentPool.id
      $pipeline_mod.environments[0].deployPhases[0].workflowTasks[0].inputs.ConnectedServiceName = "${var.sc_id}"
      $pipeline_mod.environments[1].deployPhases[0].workflowTasks[0].inputs.ConnectedServiceName = "${var.sc_id}"
      $pipeline_mod.environments[0].deployPhases[0].workflowTasks[0].inputs.WebAppName = '$(env)-${var.general.project_name}-api-app'
      $pipeline_mod.environments[1].deployPhases[0].workflowTasks[0].inputs.WebAppName = '$(env)-${var.general.project_name}-api-app'

      $pipeline_mod.artifacts[0].alias = "_${var.release_pipeline_variables.repo_api_name}"
      $pipeline_mod.artifacts[0].definitionReference.project.name = "${var.general.project_name}"
      $pipeline_mod.artifacts[0].definitionReference.project.id = "${var.project_id}"
      $pipeline_mod.artifacts[0].definitionReference.definition.name = "${var.release_pipeline_variables.repo_api_name}"
      $pipeline_mod.artifacts[0].definitionReference.definition.id = $build.id

      $pipeline_mod.triggers[0].artifactAlias = "_${var.release_pipeline_variables.repo_api_name}"

      $pipeline = $pipeline_mod | ConvertTo-Json -Depth 100
      $pipeline | Set-Content -Path "${path.module}${local.json_data[1].pipeline_path}"

      $url_pipeline = "https://vsrm.dev.azure.com/${var.general.organization_name}/${var.general.project_name}/_apis/release/definitions?api-version=7.0"
      $pipeline = Get-Content -Raw -Path "${path.module}${local.json_data[1].pipeline_path}"
      $response = Invoke-RestMethod -Uri $url_pipeline -Method Post -Body $pipeline -ContentType "application/json" -Headers $headers 

    EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}
