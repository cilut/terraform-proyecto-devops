output "project_id" {
  value = azuredevops_project.example.id
}

output "wiki_url" {
  value = module.wiki.wiki_url
}

output "dashboard_url" {
  value = module.dashboard.dashboard_url
}

output "build_pipeline_id" {
  value = module.build.build_pipeline_id
}

output "release_pipeline_id" {
  value = module.release.release_pipeline_id
}
