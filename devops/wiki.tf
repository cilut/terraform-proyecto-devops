resource "azuredevops_wiki" "example" {
  name = "example-wiki"
  project_id = var.project_id
}
