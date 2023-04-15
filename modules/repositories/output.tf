

output "repos_output" {
  value = {
    for repo in azuredevops_git_repository.repos : repo.name => repo.id
  }
}
