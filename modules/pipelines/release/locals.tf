locals {
  json_data = jsondecode(file("${path.module}/pipelines.json"))
  tg_data   = jsondecode(file("${path.module}/task_groups.json"))
}
