resource "azuredevops_dashboard" "example" {
  name = "example-dashboard"
  project_id = var.project_id

  widget {
    name = "Build Status"
    type = "Build"

    settings = jsonencode({
      project = var.project_name
      pipeline = module.build.build_pipeline_name
      branch = "main"
    })
  }

  widget {
    name = "Release Status"
    type = "Release"

    settings = jsonencode({
      project = var.project_name
      pipeline = module.release.release_pipeline_name
      environment = "production"
    })
  }
}
