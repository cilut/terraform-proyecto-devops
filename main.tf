
module "project" {
  source = "./modules/project"

  general              = var.general
  p_connection_service = var.connection_service
  teams                = var.teams
}


module "repositories" {
  depends_on = [
    module.project
  ]
  source = "./modules/repositories"

  # Pasa las variables requeridas por el módulo
  repositories  = var.repositories
  rp_project_id = module.project.p_project_id
  general       = var.general
}

module "build_pipelines" {
  depends_on = [
    module.repositories
  ]

  source = "./modules/pipelines/build"

  bp_build_pipelines = var.build_pipelines
  general            = var.general
  bp_project_id      = module.project.p_project_id
  bp_repos_output    = module.repositories.repos_output

}

module "release_pipelines" {
  depends_on = [
    module.repositories, module.project
  ]

  source = "./modules/pipelines/release"

  general                           = var.general
  release_pipeline_variables        = var.release_pipeline_variables
  project_id                        = module.project.p_project_id
  release_pipeline_variables_groups = var.release_pipeline_variables_groups
  sc_id                             = module.project.sc_id
}

module "work_items" {
  depends_on = [
    module.repositories
  ]

  source        = "./modules/work_items"
  wi_project_id = module.project.p_project_id
  general       = var.general

}
