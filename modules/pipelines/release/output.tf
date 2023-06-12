output "dev_vg_id" {
  value = azuredevops_variable_group.vg_infra_pipeline[0].id
}

output "prod_vg_id" {
  value = azuredevops_variable_group.vg_infra_pipeline[1].id
}

