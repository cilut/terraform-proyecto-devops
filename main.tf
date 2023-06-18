
module "project" {
  source = "./modules/project"

  general = var.general
  #p_project_name               = var.project_name
  p_connection_service = var.connection_service
  teams                = var.teams
  #p_organization_name          = var.organization_name
  #p_azdo_personal_access_token = var.azdo_personal_access_token
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
  #rp_project_name      = var.project_name
  #rp_organization_name = var.organization_name
}

module "build_pipelines" {
  depends_on = [
    module.repositories
  ]

  source = "./modules/pipelines/build"

  bp_build_pipelines = var.build_pipelines
  general            = var.general
  #bp_project_name      = var.project_name
  #bp_organization_name = var.organization_name
  bp_project_id   = module.project.p_project_id
  bp_repos_output = module.repositories.repos_output

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

# module "build_pipelines" {  
#   depends_on = [
#     module.repositories
#   ]

#   source = "./modules/work_items"

#   bp_build_pipelines = var.build_pipelines  
#   bp_project_name = var.project_name
#   bp_organization_name = var.organization_name
#   bp_project_id = module.project.p_project_id
#   bp_repos_output = module.repositories.repos_output

# }

module "work_items" {
  depends_on = [
    module.repositories
  ]

  source        = "./modules/work_items"
  wi_project_id = module.project.p_project_id
  general       = var.general

}
