# tests/upgrade_compat.tftest.hcl
# Purpose: catch breaking resource changes before dev tests on real infra.
# baseline_apply simulates the currently-deployed (pre-upgrade) config;
# upgrade_plan_no_replacement plans the upgraded code against that state.
mock_provider "azurerm" {}
mock_provider "http" {}

variables {
  env                  = "Dev"
  group                = "OPS"
  project              = "CORE"
  userDefinedString    = "test"
  resource_groups      = { rg-test = { name = "rg-test", location = "canadacentral" } }
  subnets              = {}
  asp                  = { myasp = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/serverFarms/myasp" }
  private_dns_zone_ids = {}
}

run "baseline_apply" {
  command = apply
  variables {
    appServiceWindows = {
      resource_group                = "rg-test"
      asp                           = "myasp"
      https_only                    = true
      public_network_access_enabled = false
      site_config = {
        always_on           = true
        http2_enabled       = true
        minimum_tls_version = "1.2"
      }
    }
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.name == "Dev-OPS-CORE-test-asv"
    error_message = "Baseline apply: unexpected resource name"
  }
}

run "upgrade_plan_no_replacement" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group                         = "rg-test"
      asp                                    = "myasp"
      https_only                             = true
      public_network_access_enabled          = false
      virtual_network_backup_restore_enabled = true
      virtual_network_image_pull_enabled     = true
      site_config = {
        always_on                = true
        http2_enabled            = true
        minimum_tls_version      = "1.2"
        minimum_tls_cipher_suite = "TLS_AES_128_GCM_SHA256"
      }
    }
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.name == "Dev-OPS-CORE-test-asv"
    error_message = "Resource name must be unchanged after upgrade"
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.virtual_network_backup_restore_enabled == true
    error_message = "virtual_network_backup_restore_enabled must be set"
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.site_config[0].minimum_tls_cipher_suite == "TLS_AES_128_GCM_SHA256"
    error_message = "minimum_tls_cipher_suite must be set"
  }
}
