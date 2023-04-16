resource "azuredevops_git_repository" "repos" {
  count = length(var.repositories)

  project_id       = var.rp_project_id
  name             = var.repositories[count.index].rp_repository_name
  initialization {
    init_type = "Uninitialized"
  }
}
## ------------------------------------------------------------------------------
##                ELIMINAMOS REPOS SI EXITEN
## ------------------------------------------------------------------------------
resource "null_resource" "remove_temp" {
  
  provisioner "local-exec" {
    interpreter = ["powershell", "-Command"]
    command = "if (Test-Path 'temp') { Remove-Item 'temp' -Recurse -Force }"
  }
}

## ------------------------------------------------------------------------------
##                SUBIMOS CODIGO DE TERRAFORM-PROYECTO-DEVOPS
## ------------------------------------------------------------------------------
resource "null_resource" "clone_repo_terraform_proyecto_devops" {
  depends_on = [
    null_resource.remove_temp
  ]
  provisioner "local-exec" {
    command = "git clone https://github.com/cilut/terraform-proyecto-devops temp/terraform-proyecto-devops/"
  }
}

resource "null_resource" "add_code_terraform_proyecto_devops" {
  depends_on = [
    null_resource.clone_repo_configuracion_azure
  ]
  provisioner "local-exec" {
    interpreter = ["powershell", "-Command"]
    command     = "cd ./temp/terraform-proyecto-devops; git remote set-url origin https://dev.azure.com/${var.rp_organization_name}/${var.rp_project_name}/_git/${var.repositories[0].rp_repository_name}; git push origin main"
  }
}


## ------------------------------------------------------------------------------
##                SUBIMOS CODIGO DE configuracion-azure
## ------------------------------------------------------------------------------
resource "null_resource" "clone_repo_configuracion_azure" {
  
  depends_on = [
    null_resource.remove_temp
  ]

  provisioner "local-exec" {
    command = "git clone https://github.com/cilut/configuracion-azure temp/configuracion-azure/"
  }
}


resource "null_resource" "add_code_configuracion_azure" {
  depends_on = [
    null_resource.clone_repo_configuracion_azure
  ]
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = "cd ./temp/configuracion-azure; git remote set-url origin https://dev.azure.com/${var.rp_organization_name}/${var.rp_project_name}/_git/${var.repositories[1].rp_repository_name}; git push origin main"
  }
}