

output "repos_output" {
  value = {
    for repo in azuredevops_git_repository.import-repositories : repo.name => repo.id
  }
}
