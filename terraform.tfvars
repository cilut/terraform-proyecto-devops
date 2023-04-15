# Variables de proyecto
project_name = "myproject"
organization_name = "CreadorProyectosOrg"

# Variables de repositorios
repositories = [ {
  rp_repository_name = "terraformDevOps"
} ]

build_pipelines = [ {
  bp_name = "despligueOtrosProyectos"
  bp_repository_name = "terraformDevOps"
} ]

release_pipelines = [ {
  rp_name = "value"
  rp_repository_name = "value"
} ]