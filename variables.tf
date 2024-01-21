variable "general" {
  type = map(string)

}
variable "connection_service" {
  type = list(object({
    p_service_endpoint_name     = string
    p_description               = string
    p_azurerm_spn_tenantid      = string
    p_azurerm_subscription_id   = string
    p_azurerm_subscription_name = string

  }))
  sensitive = true
}

variable "repositories" {
  type = list(object({
    rp_repository_name = string
    source_url         = string
  }))
}

variable "build_pipelines" {
  type = list(object({
    bp_name            = string
    bp_repository_name = string
    bp_path            = string
    bp_fichero_yml     = string
  }))
}

variable "release_pipelines" {
  type = list(object({
    rp_name            = string
    rp_repository_name = string
  }))
}


variable "teams" {
  type = list(object({
    name        = string
    description = string
  }))
}


variable "release_pipeline_variables" {
  type = map(any)
}

variable "release_pipeline_variables_groups" {
  type = list(map(string))
}
