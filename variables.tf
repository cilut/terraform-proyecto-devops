variable "azdo_org_service_url" {
  type = string
  default = "https://dev.azure.com/CreadorProyectosOrg"
}

variable "azdo_personal_access_token" {
  type = string
  default = ""
}

variable "project_name" {
  type = string
  default = ""
}

variable "organization_name" {
  type = string
  default = ""
}


variable "repositories" {
  type = list(object({
    rp_repository_name   = string
  }))
}

variable "build_pipelines" {
  type = list(object({
    bp_name              = string
    bp_repository_name   = string
  }))
}

variable "release_pipelines" {
  type = list(object({
    rp_name              = string
    rp_repository_name   = string
  }))
}
