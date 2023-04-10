resource "azuredevops_build_pipeline" "angular_app" {
  project_id = var.project_id
  repository_name = var.angular_app_repository_name
  name = "Angular App Build Pipeline"
  branch = "main"
  queue_id = 1

  trigger {
    trigger_type = "batch"
    batch_configuration {
      max_batch_size = 10
      branch_filters = [
        "refs/heads/main"
      ]
    }
  }

  variable {
    name = "build_configuration"
    value = "Release"
  }

  variable {
    name = "app_name"
    value = "Angular App"
  }

  step {
    task_id = "d4d7bdf0-9ac6-4e4d-aadf-4cd5be4eb05b"
    version_spec = "2.*"
    display_name = "npm install"
  }

  step {
    task_id = "6c2f6e80-4cd2-4d3d-aaf9-beb6a43b4d55"
    version_spec = "1.*"
    display_name = "npm build"
  }

  step {
    task_id = "71a9a2d3-a98a-4caa-96ab-affca411ecda"
    version_spec = "2.*"
    display_name = "Archive files"
    inputs = jsonencode({
      rootFolderOrFile: "$(Build.Repository.LocalPath)/dist/angular-app",
      includeRootFolder: true
    })
  }

  artifact {
    name = "drop"
    type = "container"
    path = "$(Build.ArtifactStagingDirectory)/dist/angular-app"
  }
}
