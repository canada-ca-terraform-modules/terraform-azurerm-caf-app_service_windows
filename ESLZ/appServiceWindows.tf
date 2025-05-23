variable "appServiceWindows" {
  default = {}
}

module "appServiceWindows" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-app_service_windows.git?ref=v1.0.4"
  for_each = var.appServiceWindows

  userDefinedString = each.key
  env = var.env
  group = var.group
  project = var.project
  resource_groups = local.resource_groups_all
  subnets = local.subnets
  appServiceWindows = each.value
  private_dns_zone_ids = local.Project-dns-zone
  asp = local.asp_id
  tags = var.tags
}
