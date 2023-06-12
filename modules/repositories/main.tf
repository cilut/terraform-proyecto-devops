# resource "azuredevops_git_repository" "repos" {
#   count = length(var.repositories)

#   project_id = var.rp_project_id
#   name       = var.repositories[count.index].rp_repository_name
#   initialization {
#     init_type = "Uninitialized"
#   }
# }
## ------------------------------------------------------------------------------
##                ELIMINAMOS REPOS SI EXITEN
## ------------------------------------------------------------------------------
# resource "null_resource" "remove_temp" {

#   provisioner "local-exec" {
#     interpreter = ["powershell", "-Command"]
#     command     = "if (Test-Path 'temp') { Remove-Item 'temp' -Recurse -Force }"
#   }
# }

## ------------------------------------------------------------------------------
##                SUBIMOS CODIGO A
## ------------------------------------------------------------------------------
# resource "null_resource" "clone_repo_terraform_proyecto_devops" {
#   depends_on = [
#     null_resource.remove_temp
#   ]

#   for_each = { for repo in var.repositories : repo.rp_repository_name => repo }

#   provisioner "local-exec" {
#     command = "git clone ${each.value.source_url} temp/${each.value.rp_repository_name}/"
#   }
# }

# resource "null_resource" "add_code_terraform_proyecto_devops" {
#   depends_on = [
#     null_resource.clone_repo_terraform_proyecto_devops
#   ]

#   for_each = { for repo in var.repositories : repo.rp_repository_name => repo }

#   provisioner "local-exec" {
#     interpreter = ["powershell", "-Command"]
#     command     = "cd ./temp/${each.value.rp_repository_name}/; git remote set-url origin https://dev.azure.com/${var.general.organization_name}/${var.general.project_name}/_git/${each.value.rp_repository_name}; git push origin main"
#   }
# }

resource "azuredevops_git_repository" "import-repositories" {
  count      = length(var.repositories)
  project_id = var.rp_project_id
  name       = var.repositories[count.index].rp_repository_name
  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = var.repositories[count.index].source_url
  }
}
