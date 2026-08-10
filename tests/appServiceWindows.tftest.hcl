# tests/appServiceWindows.tftest.hcl
# Functional (plan-only) coverage for azurerm_windows_web_app and its
# associated resources (custom hostname binding, public certificate,
# private endpoint). mock_provider intercepts all API calls.

mock_provider "azurerm" {}
mock_provider "http" {}

variables {
  env                  = "Dev"
  group                = "OPS"
  project              = "CORE"
  userDefinedString    = "test"
  resource_groups      = { rg-test = { name = "rg-test", location = "canadacentral" } }
  subnets              = { OZ = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/OZ" } }
  asp                  = { myasp = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/serverFarms/myasp" }
  private_dns_zone_ids = {}
}

run "naming_convention" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group = "rg-test"
      asp            = "myasp"
      site_config    = { always_on = true }
    }
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.name == "Dev-OPS-CORE-test-asv"
    error_message = "Name must follow {env}-{group}-{project}-{userDefinedString}-asv convention"
  }
}

run "default_values" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group = "rg-test"
      asp            = "myasp"
      site_config    = { always_on = true }
    }
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.https_only == true
    error_message = "https_only must default to true"
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.site_config[0].ftps_state == "Disabled"
    error_message = "ftps_state must default to Disabled"
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.site_config[0].remote_debugging_version == "VS2022"
    error_message = "remote_debugging_version must default to VS2022 (only version supported by azurerm >= 5.0)"
  }
}

run "new_arguments_azurerm_5_0" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group                         = "rg-test"
      asp                                    = "myasp"
      virtual_network_backup_restore_enabled = true
      virtual_network_image_pull_enabled     = true
      site_config = {
        always_on                = true
        minimum_tls_cipher_suite = "TLS_AES_128_GCM_SHA256"
      }
    }
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.virtual_network_backup_restore_enabled == true
    error_message = "virtual_network_backup_restore_enabled must be settable (new in azurerm >= 5.0)"
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.virtual_network_image_pull_enabled == true
    error_message = "virtual_network_image_pull_enabled must be settable (new in azurerm >= 5.0)"
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.site_config[0].minimum_tls_cipher_suite == "TLS_AES_128_GCM_SHA256"
    error_message = "minimum_tls_cipher_suite must be settable (new in azurerm >= 5.0)"
  }
}

run "vnet_integration" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group            = "rg-test"
      asp                       = "myasp"
      virtual_network_subnet_id = "OZ"
      site_config               = { always_on = true }
    }
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.virtual_network_subnet_id != null
    error_message = "virtual_network_subnet_id must resolve from subnets map"
  }
}

run "inject_root_cert" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group   = "rg-test"
      asp              = "myasp"
      inject_root_cert = true
      site_config      = { always_on = true }
    }
  }
  assert {
    condition     = length(azurerm_app_service_public_certificate.internal-ca) == 1
    error_message = "inject_root_cert must create the public certificate resource"
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.app_settings["WEBSITE_LOAD_ROOT_CERTIFICATES"] == "8EBD38E4D2A40158C4CA179E791D239D7F520F0A"
    error_message = "inject_root_cert must inject the WEBSITE_LOAD_ROOT_CERTIFICATES app setting"
  }
}

run "custom_hostname_binding" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group          = "rg-test"
      asp                     = "myasp"
      site_config             = { always_on = true }
      custom_hostname_binding = ["example.com"]
    }
  }
  assert {
    condition     = length(azurerm_app_service_custom_hostname_binding.hostname) == 1
    error_message = "custom_hostname_binding must create one hostname binding per entry"
  }
}

run "private_endpoint" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group = "rg-test"
      asp            = "myasp"
      site_config    = { always_on = true }
      private_endpoint = {
        asv = {
          resource_group       = "rg-test"
          subnet               = "OZ"
          subresource_names    = ["sites"]
          is_manual_connection = false
        }
      }
    }
  }
  assert {
    condition     = length(module.private_endpoint) == 1
    error_message = "private_endpoint object must create the private_endpoint child module instance"
  }
}

run "identity" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group = "rg-test"
      asp            = "myasp"
      site_config    = { always_on = true }
      identity       = { type = "SystemAssigned" }
    }
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.identity[0].type == "SystemAssigned"
    error_message = "identity block must be applied"
  }
}

run "backup" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group = "rg-test"
      asp            = "myasp"
      site_config    = { always_on = true }
      backup = {
        mybackup = {
          storage_account_url = "https://example.blob.core.windows.net/backups?sv=x"
          schedule = {
            frequency_interval = 7
            frequency_unit     = "Day"
          }
        }
      }
    }
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.backup[0].name == "mybackup"
    error_message = "backup block name must come from the map key"
  }
}

run "connection_string" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group = "rg-test"
      asp            = "myasp"
      site_config    = { always_on = true }
      connection_string = {
        default = { type = "SQLAzure", value = "Server=tcp:example;" }
      }
    }
  }
  assert {
    condition     = tolist(azurerm_windows_web_app.webapp.connection_string)[0].name == "default"
    error_message = "connection_string block name must come from the map key"
  }
}

run "logs" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group = "rg-test"
      asp            = "myasp"
      site_config    = { always_on = true }
      logs = {
        default = {
          detailed_error_messages = true
          failed_request_tracing  = true
        }
      }
    }
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.logs[0].detailed_error_messages == true
    error_message = "logs block must be applied"
  }
}

run "storage_account" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group = "rg-test"
      asp            = "myasp"
      site_config    = { always_on = true }
      storage_account = {
        default = {
          access_key   = "fake-access-key"
          account_name = "examplesa"
          name         = "examplemount"
          share_name   = "exampleshare"
          type         = "AzureFiles"
        }
      }
    }
  }
  assert {
    condition     = tolist(azurerm_windows_web_app.webapp.storage_account)[0].name == "examplemount"
    error_message = "storage_account block must be applied"
  }
}

run "auth_settings_legacy" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group = "rg-test"
      asp            = "myasp"
      site_config    = { always_on = true }
      auth_settings = {
        default = { enabled = true }
      }
    }
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.auth_settings[0].enabled == true
    error_message = "auth_settings (v1) block must still be supported"
  }
}

run "auth_settings_v2" {
  command = plan
  variables {
    appServiceWindows = {
      resource_group = "rg-test"
      asp            = "myasp"
      site_config    = { always_on = true }
      auth_settings_v2 = {
        default = {
          auth_enabled = true
          login        = {}
          active_directory_v2 = {
            default = {
              client_id            = "00000000-0000-0000-0000-000000000000"
              tenant_auth_endpoint = "https://login.microsoftonline.com/00000000-0000-0000-0000-000000000000/v2.0"
            }
          }
        }
      }
    }
  }
  assert {
    condition     = azurerm_windows_web_app.webapp.auth_settings_v2[0].auth_enabled == true
    error_message = "auth_settings_v2 block must be supported"
  }
}
