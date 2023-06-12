locals {
  json_data = jsondecode(file("${path.module}/work_items.json"))
}
