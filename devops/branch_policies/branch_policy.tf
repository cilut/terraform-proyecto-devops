resource "azuredevops_policy_approver_count" "example" {
  project_id = azuredevops_project.example.id
  repository_id = azuredevops_git_repository.example.id
  policy_configuration {
    minimumApproverCount = var.branch_policy_approver_count
    creatorVoteCounts = true
    allowDownvotes = true
  }
}
