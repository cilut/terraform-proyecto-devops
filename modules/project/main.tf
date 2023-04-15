
resource "azuredevops_project" "project" {

  name = var.p_project_name
  description = "This is an example project"
  visibility = "private"

}