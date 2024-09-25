variable "appServiceWindows" {
  default = {}
}

module "appServiceWindows" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-app_service_linux.git?ref=v1.0.0"
  for_each = var.appServiceWindows

  userDefinedString = each.key
  env = var.env
  group = var.group
  project = var.project
  resource_groups = local.resource_groups_all
  subnets = local.subnets
  appServiceWindows = each.value
  tags = var.tags
}
