#resource "azuredevops_workitem" "work_items" {
#  count = length(local.json_data)
#
#  project_id = var.wi_project_id
#  title      = local.json_data[count.index].title
#  type       = local.json_data[count.index].type
#  custom_fields = {
#      description : local.json_data[count.index].description
#    }
#
#}



resource "null_resource" "import_work_items" {
  # for_each = local.json_data
  for_each = { for repo in local.json_data : repo.title => repo }


  provisioner "local-exec" {

    interpreter = ["PowerShell", "-Command"]
    command     = <<-EOT
      az boards work-item create --title "${each.value.title}" --organization 'https://dev.azure.com/${var.general.organization_name}/' --type "${each.value.type}" --description "${each.value.description}" --project "${var.general.project_name}" --area "${var.general.project_name}\\${each.value.path}" 
    EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}
