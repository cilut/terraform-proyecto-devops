resource "azuredevops_project" "example" {
  name = var.project_name
  description = "This is an example project"
  visibility = "private"
}
