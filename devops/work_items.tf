locals {
    work_items = jsondecode(file("./work_items.json"))
}
  
resource "azuredevops_work_item" "example" {
    for_each = local.work_items

    project_id = var.project_id
    type = each.value.type
    title = each.value.title
    description = each.value.description
    area_path = each.value.area_path
    iteration_path = each.value.iteration_path
}
  