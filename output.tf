output "appServiceWindows-object" {
  description = "Outputs the entire App Service object"
  # Rebuilt as an explicit object literal (never the bare resource reference)
  # to avoid the "Deprecated value used" warning that fires whenever the
  # whole azurerm_windows_web_app object is output as-is: azurerm >= 5.0
  # deprecated site_config.application_stack.java_container and
  # .java_container_version in favour of tomcat_version /
  # java_embedded_server_enabled. Every other attribute is preserved for
  # parity - only those two leaves are omitted.
  value = {
    id                                             = azurerm_windows_web_app.webapp.id
    name                                           = azurerm_windows_web_app.webapp.name
    resource_group_name                            = azurerm_windows_web_app.webapp.resource_group_name
    location                                       = azurerm_windows_web_app.webapp.location
    service_plan_id                                = azurerm_windows_web_app.webapp.service_plan_id
    app_settings                                   = azurerm_windows_web_app.webapp.app_settings
    client_affinity_enabled                        = azurerm_windows_web_app.webapp.client_affinity_enabled
    client_certificate_enabled                     = azurerm_windows_web_app.webapp.client_certificate_enabled
    client_certificate_mode                        = azurerm_windows_web_app.webapp.client_certificate_mode
    client_certificate_exclusion_paths             = azurerm_windows_web_app.webapp.client_certificate_exclusion_paths
    custom_domain_verification_id                  = azurerm_windows_web_app.webapp.custom_domain_verification_id
    default_hostname                               = azurerm_windows_web_app.webapp.default_hostname
    enabled                                        = azurerm_windows_web_app.webapp.enabled
    ftp_publish_basic_authentication_enabled       = azurerm_windows_web_app.webapp.ftp_publish_basic_authentication_enabled
    hosting_environment_id                         = azurerm_windows_web_app.webapp.hosting_environment_id
    https_only                                     = azurerm_windows_web_app.webapp.https_only
    key_vault_reference_identity_id                = azurerm_windows_web_app.webapp.key_vault_reference_identity_id
    kind                                           = azurerm_windows_web_app.webapp.kind
    outbound_ip_address_list                       = azurerm_windows_web_app.webapp.outbound_ip_address_list
    outbound_ip_addresses                          = azurerm_windows_web_app.webapp.outbound_ip_addresses
    possible_outbound_ip_address_list              = azurerm_windows_web_app.webapp.possible_outbound_ip_address_list
    possible_outbound_ip_addresses                 = azurerm_windows_web_app.webapp.possible_outbound_ip_addresses
    public_network_access_enabled                  = azurerm_windows_web_app.webapp.public_network_access_enabled
    tags                                           = azurerm_windows_web_app.webapp.tags
    virtual_network_backup_restore_enabled         = azurerm_windows_web_app.webapp.virtual_network_backup_restore_enabled
    virtual_network_image_pull_enabled             = azurerm_windows_web_app.webapp.virtual_network_image_pull_enabled
    virtual_network_subnet_id                      = azurerm_windows_web_app.webapp.virtual_network_subnet_id
    webdeploy_publish_basic_authentication_enabled = azurerm_windows_web_app.webapp.webdeploy_publish_basic_authentication_enabled
    zip_deploy_file                                = azurerm_windows_web_app.webapp.zip_deploy_file
    identity                                       = azurerm_windows_web_app.webapp.identity
    site_credential                                = azurerm_windows_web_app.webapp.site_credential
    auth_settings                                  = azurerm_windows_web_app.webapp.auth_settings
    auth_settings_v2                               = azurerm_windows_web_app.webapp.auth_settings_v2
    backup                                         = azurerm_windows_web_app.webapp.backup
    connection_string                              = azurerm_windows_web_app.webapp.connection_string
    logs                                           = azurerm_windows_web_app.webapp.logs
    storage_account                                = azurerm_windows_web_app.webapp.storage_account
    sticky_settings                                = azurerm_windows_web_app.webapp.sticky_settings

    # site_config rebuilt explicitly - omits application_stack.java_container
    # and .java_container_version (deprecated, azurerm >= 5.0)
    site_config = [
      for sc in azurerm_windows_web_app.webapp.site_config : merge(
        {
          always_on                                     = sc.always_on
          api_definition_url                            = sc.api_definition_url
          api_management_api_id                         = sc.api_management_api_id
          app_command_line                              = sc.app_command_line
          container_registry_managed_identity_client_id = sc.container_registry_managed_identity_client_id
          container_registry_use_managed_identity       = sc.container_registry_use_managed_identity
          default_documents                             = sc.default_documents
          detailed_error_logging_enabled                = sc.detailed_error_logging_enabled
          ftps_state                                    = sc.ftps_state
          health_check_path                             = sc.health_check_path
          health_check_eviction_time_in_min             = sc.health_check_eviction_time_in_min
          http2_enabled                                 = sc.http2_enabled
          ip_restriction_default_action                 = sc.ip_restriction_default_action
          linux_fx_version                              = sc.linux_fx_version
          load_balancing_mode                           = sc.load_balancing_mode
          local_mysql_enabled                           = sc.local_mysql_enabled
          managed_pipeline_mode                         = sc.managed_pipeline_mode
          minimum_tls_version                           = sc.minimum_tls_version
          minimum_tls_cipher_suite                      = sc.minimum_tls_cipher_suite
          remote_debugging_enabled                      = sc.remote_debugging_enabled
          remote_debugging_version                      = sc.remote_debugging_version
          scm_ip_restriction_default_action             = sc.scm_ip_restriction_default_action
          scm_minimum_tls_version                       = sc.scm_minimum_tls_version
          scm_type                                      = sc.scm_type
          scm_use_main_ip_restriction                   = sc.scm_use_main_ip_restriction
          use_32_bit_worker                             = sc.use_32_bit_worker
          vnet_route_all_enabled                        = sc.vnet_route_all_enabled
          websockets_enabled                            = sc.websockets_enabled
          windows_fx_version                            = sc.windows_fx_version
          worker_count                                  = sc.worker_count
          auto_heal_setting                             = sc.auto_heal_setting
          cors                                          = sc.cors
          handler_mapping                               = sc.handler_mapping
          ip_restriction                                = sc.ip_restriction
          scm_ip_restriction                            = sc.scm_ip_restriction
          virtual_application                           = sc.virtual_application
        },
        {
          application_stack = [
            for stack in sc.application_stack : {
              current_stack                = stack.current_stack
              docker_image_name            = stack.docker_image_name
              docker_registry_url          = stack.docker_registry_url
              docker_registry_username     = stack.docker_registry_username
              docker_registry_password     = stack.docker_registry_password
              dotnet_version               = stack.dotnet_version
              dotnet_core_version          = stack.dotnet_core_version
              tomcat_version               = stack.tomcat_version
              java_embedded_server_enabled = stack.java_embedded_server_enabled
              java_version                 = stack.java_version
              node_version                 = stack.node_version
              php_version                  = stack.php_version
              python                       = stack.python
              # java_container / java_container_version intentionally
              # omitted - deprecated in favour of tomcat_version /
              # java_embedded_server_enabled (azurerm >= 5.0)
            }
          ]
        }
      )
    ]
  }
  sensitive = true
}

output "id" {
  description = "Outputs the ID of the App Service"
  value       = azurerm_windows_web_app.webapp.id
}

output "name" {
  description = "Outputs the name of the App Service"
  value       = azurerm_windows_web_app.webapp.name
}
