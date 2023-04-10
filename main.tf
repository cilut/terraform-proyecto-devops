resource "azuredevops_project" "example" {
  name = var.project_name
}

module "wiki" {
  source = "./wiki"

  project_id = azuredevops_project.example.id
}

module "dashboard" {
  source = "./dashboard"

  project_id = azuredevops_project.example.id
}

module "work_items" {
  source = "./work_items"

  project_id = azuredevops_project.example.id
  work_items_json = file("${path.module}/work_items.json")
}

module "repositories" {
  source = "./repositories"

  project_id = azuredevops_project.example.id
  angular_app_repository_name = var.angular_app_repository_name
}

module "build" {
  source = "./build"

  project_id = azuredevops_project.example.id
  angular_app_repository_name = var.angular_app_repository_name
}

module "release" {
  source = "./release"

  project_id = azuredevops_project.example.id
  build_pipeline_id = module.build.build_pipeline_id
}
