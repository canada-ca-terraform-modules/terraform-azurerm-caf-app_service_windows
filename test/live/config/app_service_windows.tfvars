appServiceWindows = {
  resource_group                = "livetest"
  asp                           = "livetest"
  https_only                    = true
  public_network_access_enabled = false

  site_config = {
    always_on = true
  }
}
