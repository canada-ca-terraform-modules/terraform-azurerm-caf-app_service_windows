locals {
  resource_group_name = strcontains(var.appServiceWindows.resource_group, "/resourceGroups/") ? regex("[^\\/]+$", var.appServiceWindows.resource_group) : var.resource_groups[var.appServiceWindows.resource_group].name

  asp = strcontains(var.appServiceWindows.asp, "/resourceGroups/") ? var.appServiceWindows.asp : var.asp[var.appServiceWindows.asp]
  # asp_rg = strcontains(var.appServiceWindows.asp.resource_group, "/resourceGroups/") ? regex("[^\\/]+$", var.appServiceWindows.asp.resource_group) : var.resource_groups[var.appServiceWindows.asp.resource_group].name

  subnet_id = try(var.appServiceWindows.virtual_network_subnet_id, null) != null ?  strcontains(var.appServiceWindows.virtual_network_subnet_id, "/resourceGroups/") ? var.appServiceWindows.virtual_network_subnet_id : var.subnets[var.appServiceWindows.virtual_network_subnet_id].id : null

}