output "appServiceWindows-object" {
  description = "Outputs the entire App Service object"
  value = azurerm_windows_web_app.webapp
}

output "id" {
  description = "Outputs the ID of the App Service"
  value = azurerm_windows_web_app.webapp.id
}

output "name" {
  description = "Outputs the name of the App Service"
  value = azurerm_windows_web_app.webapp.name
}