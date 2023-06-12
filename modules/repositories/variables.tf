variable "repositories" {
  type = list(object({
    rp_repository_name = string
    source_url         = string
  }))
}

variable "general" {
  type = map(string)
  default = {
    project_name               = ""
    organization_name          = ""
    azdo_org_service_url       = ""
    azdo_personal_access_token = ""
  }
}

variable "rp_project_id" {
  type    = string
  default = ""
}

#variable "rp_organization_name" {
#  type    = string
#  default = ""
#}
#variable "rp_project_name" {
#  type    = string
#  default = ""
#}
