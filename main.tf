module "project"{
  source = "./modules/project"

  p_project_name = var.project_name
}


module "repositories"{
  source = "./modules/repositories"

  # Pasa las variables requeridas por el módulo
  repositories = var.repositories
  rp_project_id = module.project.p_project_id
  rp_project_name = var.project_name
  rp_organization_name = var.organization_name
}

module "build_pipelines" {
  source = "./modules/pipelines/build"

  bp_build_pipelines = var.build_pipelines  
  bp_project_name = var.project_name
  bp_organization_name = var.organization_name
  bp_project_id = module.project.p_project_id
  bp_repos_output = module.repositories.repos_output
  
}
