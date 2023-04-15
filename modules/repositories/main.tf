resource "azuredevops_git_repository" "repos" {
  count = length(var.repositories)

  project_id       = var.rp_project_id
  name             = var.repositories[count.index].rp_repository_name
  initialization {
    init_type = "Uninitialized"
  }
}

# resource "null_resource" "clone_repo" {
#   provisioner "local-exec" {
#     command = "git clone https://github.com/cilut/terraform-proyecto-devops"
#   }
# }

resource "null_resource" "add_code" {
  
  # provisioner "local-exec" {
  #   command = "cd ./terraform-proyecto-devops"
  # }
  provisioner "local-exec" {
    command = "git remote set-url origin https://dev.azure.com/${var.rp_organization_name}/${var.rp_project_name}/_git/${var.repositories[0].rp_repository_name}"
  }
  provisioner "local-exec" {
    command = "git push origin main"
  }
}

