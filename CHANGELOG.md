# Changelog

All notable changes to this module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.1.0] - 2026-08-10

### Added

- `virtual_network_backup_restore_enabled` argument on `azurerm_windows_web_app` (new in azurerm >= 5.0).
- `virtual_network_image_pull_enabled` argument on `azurerm_windows_web_app` (new in azurerm >= 5.0).
- `site_config.minimum_tls_cipher_suite` argument (new in azurerm >= 5.0).
- `providers.tf` pinning `azurerm ~> 5.0` and `http ~> 3.6` (`.terraform.lock.hcl` previously absent).
- `.tflint.hcl` (using `call_module_type = "local"`), `.gitignore`, `.gitattributes`.
- `tests/appServiceWindows.tftest.hcl` (14 runs) and `tests/upgrade_compat.tftest.hcl` (2 runs) — `mock_provider`-based coverage of every existing optional block plus the new azurerm 5.0 arguments.
- `.github/workflows/terraform-ci.yml` (fmt, init, validate, test, tflint) and `.github/workflows/release.yml` (release-on-merge, tag sourced from `ESLZ/appServiceWindows.tf`'s `?ref=`).
- Static usage documentation (title, ESLZ module block, tfvars pattern, new-arguments table) above the `<!-- BEGIN_TF_DOCS -->` marker in `README.md`.

### Changed

- Bumped child module `terraform-azurerm-caf-private_endpoint` pin from `v1.0.2` to `v1.2.0` (additive-only interface change: `custom_network_interface_name`, `ip_configuration`, `private_connection_resource_alias` — no breaking changes for existing callers).
- Bumped `ESLZ/appServiceWindows.tf` module ref from `v1.0.4` to `v1.1.0`.
- `output.appServiceWindows-object` now marked `sensitive = true` (exposes the full resource object; required for `mock_provider` test compatibility).
- Fixed a copy-paste artifact in `variable.appServiceWindows`'s description ("Linux App Service" -> "Windows App Service").
- Updated GitHub Actions pins in `.github/workflows/documentation.yml` (`actions/checkout@v7.0.1`, `terraform-docs/gh-actions@v1.4.1`).

### Fixed

- `appServiceWindows-object` output rebuilt as an explicit object literal (never the bare `azurerm_windows_web_app.webapp` reference) to eliminate a `Deprecated value used` warning on every plan/apply, surfaced by the live upgrade probe. azurerm >= 5.0 deprecated `site_config.application_stack.java_container` and `.java_container_version` in favour of `tomcat_version`/`java_embedded_server_enabled`; the resource always exposes these fields as computed attributes (even when unset by the caller), so referencing the whole resource object always tripped the warning regardless of config. Every other attribute is preserved for full parity — confirmed via `terraform state show` against a live-deployed instance and re-verified with the live probe harness (warning present on the unmodified v1.0.4 baseline, absent on the fixed local checkout).

### Notes

- No variable removals, resource renames, or naming-convention changes were found in git history — no `moved` blocks or Pattern 10/11 compat shims were required.
- `azurerm_app_service_custom_hostname_binding`, `azurerm_app_service_public_certificate`, and `data.http.cert` have no breaking changes between the previously-unpinned provider version and azurerm 5.0.1 / http 3.6.0.
- `remote_debugging_version` in azurerm >= 5.0 only supports `VS2022` — the module's default was already `VS2022`, so no change was required.
- Live upgrade probe (`terraform-module-upgrade-probe` skill) confirmed a clean, purely additive upgrade: `0 to add, 1 to change, 0 to destroy` when the 3 new arguments are explicitly set, and `0 to add, 0 to change, 0 to destroy` when they're left unset — the module never forces changes onto existing resources that don't opt into the new arguments.
