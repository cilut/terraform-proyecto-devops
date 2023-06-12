
variable "wi_project_id" {
  type = string
}

#variable "general_info_wi" {
#  type = map(any)
#}

variable "general" {
  type = map(string)
  default = {
    project_name               = ""
    organization_name          = ""
    azdo_org_service_url       = ""
    azdo_personal_access_token = ""
  }
}
