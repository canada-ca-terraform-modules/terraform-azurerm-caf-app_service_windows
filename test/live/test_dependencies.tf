# test_dependencies.tf
# Self-contained dependency resources, owned entirely by this harness.
#
# Deliberately NOT reusing any shared/production resource group or App
# Service Plan: writing into a shared RG/ASP usually requires elevated,
# non-sandbox permissions. A dedicated throwaway RG+ASP here needs only
# Contributor on the sandbox subscription and can never collide with or
# affect any production App Service.

resource "azurerm_resource_group" "live_test" {
  # PR-number suffix keeps two concurrently open PRs against this module from
  # colliding on the same sandbox resource group.
  name     = "${var.env}-caf-app-service-windows-live-test-${var.pr_number}-rg"
  location = var.location

  # pr-number tag (ticket 13): lets the nightly orphan sweeper find this RG
  # by tag and match it back to a PR, independent of naming convention.
  # repository tag: the sandbox subscription is shared across module repos
  # (ticket 03), so the sweeper must scope its `pr-number` matches to only
  # this repo's own PRs - otherwise a PR number collision across repos could
  # misclassify (or destroy) another repo's live resource group.
  tags = {
    "pr-number"  = var.pr_number
    "repository" = var.repository
  }
}

resource "azurerm_service_plan" "live_test" {
  name                = "${var.env}-caf-asw-live-test-${var.pr_number}-asp"
  resource_group_name = azurerm_resource_group.live_test.name
  location            = azurerm_resource_group.live_test.location
  os_type             = "Windows"
  sku_name            = "B1"

  tags = {
    "pr-number"  = var.pr_number
    "repository" = var.repository
  }
}

locals {
  # terraform-azurerm-caf-app_service_windows expects resource_groups as a
  # map keyed by name -> { name, location } (locals.tf:
  # var.resource_groups[var.appServiceWindows.resource_group].name).
  resource_groups = {
    livetest = {
      name     = azurerm_resource_group.live_test.name
      location = azurerm_resource_group.live_test.location
    }
  }

  # terraform-azurerm-caf-app_service_windows expects asp as a map keyed by
  # name -> Service Plan ID directly (locals.tf: var.asp[var.appServiceWindows.asp]).
  asp = {
    livetest = azurerm_service_plan.live_test.id
  }
}
