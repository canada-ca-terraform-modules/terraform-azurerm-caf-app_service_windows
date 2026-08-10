# terraform-azurerm-caf-app_service_windows

Terraform CAF module to deploy an Azure Windows Web App (`azurerm_windows_web_app`), with optional custom hostname bindings, an internal root CA public certificate, and private endpoint(s).

## Usage

### ESLZ module block (`ESLZ/appServiceWindows.tf`)

```hcl
module "appServiceWindows" {
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-app_service_windows.git?ref=v1.1.0"
  for_each = var.appServiceWindows

  userDefinedString    = each.key
  env                  = var.env
  group                = var.group
  project              = var.project
  resource_groups      = local.resource_groups_all
  subnets              = local.subnets
  appServiceWindows    = each.value
  private_dns_zone_ids = local.Project-dns-zone
  asp                  = local.asp_id
  tags                 = var.tags
}
```

### ESLZ tfvars pattern (`ESLZ/appServiceWindows.tfvars`)

```hcl
appServiceWindows = {
  test = {
    resource_group = "Project"
    asp            = "name"
    https_only     = true
    site_config = {
      always_on = true
    }
  }
}
```

## New arguments (azurerm >= 5.0)

| Key | Type | Description |
|---|---|---|
| `virtual_network_backup_restore_enabled` | bool | Whether backup and restore operations over the linked virtual network are enabled (optional) |
| `virtual_network_image_pull_enabled` | bool | Whether traffic for the image pull should be routed over the virtual network (optional) |
| `site_config.minimum_tls_cipher_suite` | string | The minimum cipher suite of TLS required for SSL requests (optional) |

## Testing

```bash
terraform fmt -recursive && terraform init -backend=false && terraform validate && terraform test
```

## CI

GitHub Actions workflow at `.github/workflows/terraform-ci.yml` runs fmt, init, validate, test, and tflint on every PR.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 5.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 5.0 |
| <a name="provider_http"></a> [http](#provider\_http) | ~> 3.6 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_endpoint"></a> [private\_endpoint](#module\_private\_endpoint) | github.com/canada-ca-terraform-modules/terraform-azurerm-caf-private_endpoint.git | v1.2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_custom_hostname_binding.hostname](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_app_service_public_certificate.internal-ca](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_public_certificate) | resource |
| [azurerm_windows_web_app.webapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app) | resource |
| [http_http.cert](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appServiceWindows"></a> [appServiceWindows](#input\_appServiceWindows) | Object containing all parameters for the Windows App Service | `any` | `{}` | no |
| <a name="input_asp"></a> [asp](#input\_asp) | Object containing a map of name and ID for the App Service Plan in the target subscription | `any` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | (Required) Env value for the name of the resource | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | (Required) Group value for the name of the resource | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure location for the resource | `string` | `"canadacentral"` | no |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | Object containing the private DNS zone IDs of the subscription. Used to configure private endpoints | `any` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | (Required) Project value for the name of the resource | `string` | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | Resouce group object containing a list of resource group in the target project | `any` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnet object containing a list of subnets in the target project | `any` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Maps of tags that will be applied to the resource | `map(string)` | `{}` | no |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | (Required) UserDefinedString value for the name of the resource | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_appServiceWindows-object"></a> [appServiceWindows-object](#output\_appServiceWindows-object) | Outputs the entire App Service object |
| <a name="output_id"></a> [id](#output\_id) | Outputs the ID of the App Service |
| <a name="output_name"></a> [name](#output\_name) | Outputs the name of the App Service |
<!-- END_TF_DOCS -->
