resource "azuredevops_workitem" "example" {
  project_id = var.wi_project_id
  title      = "Example Work Item"
  type       = "Issue"
  state      = "Active"
  tags       = ["Tag"]
}