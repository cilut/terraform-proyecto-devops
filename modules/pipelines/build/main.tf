
resource "azuredevops_variable_group" "example" {
  project_id   = var.bp_project_id
  name         = "Example Pipeline Variables"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "FOO"
    value = "BAR"
  }
}

resource "azuredevops_build_definition" "example" {
  count = length(var.bp_build_pipelines)

  project_id = var.bp_project_id
  name       = var.bp_build_pipelines[count.index].bp_name
  path       = "\\${var.bp_build_pipelines[count.index].bp_path}"

  ci_trigger {
    use_yaml = false
  }

  schedules {
    branch_filter {
      include = ["main"]
      exclude = ["test", "regression"]
    }
    days_to_build              = ["Wed", "Sun"]
    schedule_only_with_changes = true
    start_hours                = 10
    start_minutes              = 59
    time_zone                  = "(UTC) Coordinated Universal Time"
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = var.bp_repos_output[var.bp_build_pipelines[count.index].bp_repository_name]
    branch_name = "main"
    yml_path    = var.bp_build_pipelines[count.index].bp_fichero_yml
  }

  variable_groups = [
    azuredevops_variable_group.example.id
  ]

  variable {
    name  = "PipelineVariable"
    value = "Go Microsoft!"
  }

  variable {
    name         = "PipelineSecret"
    secret_value = "ZGV2cw"
    is_secret    = true
  }
}
