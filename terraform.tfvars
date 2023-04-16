# Variables de proyecto
project_name = "NOMBRE_PROYECTO"
organization_name = "NOMBRE_ORGANIZACION"
azdo_org_service_url = "https://dev.azure.com/NOMBRE_ORGANIZACION/"
azdo_personal_access_token = "ACTUALZIAR_PAT"

connection_service = [ {
  p_azurerm_spn_tenantid = "000000-0000-0000-0000-0000000000"
  p_azurerm_subscription_id = "000000-0000-0000-0000-0000000000"
  p_azurerm_subscription_name = "nombreSuscripcion"
  p_serviceprincipalid = "000000-0000-0000-0000-0000000000"
  p_serviceprincipalkey = "asdfasdgasdfgadshaklsjdhfkajshdgfkjashdfk"
  p_description = "Managed by Terraform"
  p_service_endpoint_name = "GeneralConnection"
} ]


# Variables de repositorios
repositories = [ 
  {
    rp_repository_name = "terraformDevOps"
  },
  {
    rp_repository_name = "configuracion-azure"
  }
 ]

build_pipelines = [ 
  {
    bp_name = "despligueOtrosProyectos"
    bp_repository_name = "terraformDevOps"
    bp_path = "Terraform DevOps"
    bp_fichero_yml = "azure-pipelines.yml"
  },
  {
    bp_name = "Initial Setup"
    bp_repository_name = "configuracion-azure"
    bp_path = "configuracion-azure"
    bp_fichero_yml = "InitialAzSetup.yml"

  },
  {
    bp_name = "Elimina rg_auxiliar y TfState - CUIDADO"
    bp_repository_name = "configuracion-azure"
    bp_path = "configuracion-azure"
    bp_fichero_yml = "RemoveAzSetup.yml"
  }
]

release_pipelines = [ {
  rp_name = "value"
  rp_repository_name = "value"
} ]