variable "general" {
  type = map(string)
  default = {
    project_name               = ""
    organization_name          = ""
    azdo_org_service_url       = ""
    azdo_personal_access_token = ""
  }
}

variable "project_id" {
  type = string
}

variable "release_pipeline_variables" {
  type = map(string)
  default = {
    repo_infra_name = ""
    repo_api_name   = ""
  }
}

variable "release_pipeline_variables_groups" {
  type = list(map(string))
  default = [{
    location                = ""
    terraformstoragerg      = ""
    terraformstorageaccount = ""
    terraformcontainer      = ""
    sku                     = ""
    name                    = ""
  }]
}
