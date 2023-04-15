variable "repositories" {
  type = list(object({
    rp_repository_name       = string
  }))
}



variable "rp_project_id" {
  type = string
  default = ""
}
variable "rp_organization_name" {
  type = string
  default = ""
}
variable "rp_project_name" {
  type = string
  default = ""
}