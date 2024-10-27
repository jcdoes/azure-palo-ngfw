resource "azurerm_resource_group" "azure-resource-group" {
  name     = var.azure-resource-group-name
  location = var.azure-region-name

  tags = merge(
    var.default-tags,
    {},
  )
}