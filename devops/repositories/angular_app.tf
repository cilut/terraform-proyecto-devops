resource "azuredevops_git_repository" "angular_app" {
  project_id = var.project_id
  name = var.angular_app_repository_name
}

resource "azuredevops_git_repository_policy" "angular_app" {
  repository_id = azuredevops_git_repository.angular_app.id

  policy {
    scope {
      ref_name = "refs/heads/*"
    }

    policy_type {
      id = "fa4e907d-c16b-4a4c-9dfa-4906e5d171dd"
    }

    settings = jsonencode({
      minimumApproverCount = 2
      creatorVoteCounts = true
      allowDownvotes = true
    })
  }
}
