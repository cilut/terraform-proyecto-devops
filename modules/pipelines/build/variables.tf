
variable "bp_project_id" {
  type = string
}

variable "bp_project_name" {
  type = string
}

variable "bp_organization_name" {
  type = string
}

variable "bp_build_pipelines" {
  type = list(object({
    bp_name              = string
    bp_repository_name   = string
    bp_path              = string
    bp_fichero_yml       = string
  }))
}

variable "bp_repos_output" {
  type = map(string)
}