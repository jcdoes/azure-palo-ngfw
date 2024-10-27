resource "azurerm_storage_account" "palo-bootstrap-storage-account" {
  name                     = var.palo-bootstrap-storage-account-name
  resource_group_name      = var.azure-resource-group-name
  location                 = var.azure-region-name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = "true"
  account_kind             = "StorageV2"

  tags = merge(
    var.default-tags,
    {},
  )
}

resource "azurerm_storage_share" "palo-bootstrap-fileshare-name" {
  name                 = var.palo-bootstrap-fileshare-name
  storage_account_name = azurerm_storage_account.palo-bootstrap-storage-account.name
  quota = 1
}

## Creates all the empty directories

resource "azurerm_storage_share_directory" "palo-bootstrap-shared-root-dir" {
  name             = var.palo-bootstrap-shared-dir-name
  storage_share_id = azurerm_storage_share.palo-bootstrap-fileshare-name.id
}

resource "azurerm_storage_share_directory" "bootstrap-dir-config" {
  name             = "${azurerm_storage_share_directory.palo-bootstrap-shared-root-dir.name}/config"
  storage_share_id = azurerm_storage_share.palo-bootstrap-fileshare-name.id
}

resource "azurerm_storage_share_directory" "bootstrap-dir-lic" {
  name             = "${azurerm_storage_share_directory.palo-bootstrap-shared-root-dir.name}/license"
  storage_share_id = azurerm_storage_share.palo-bootstrap-fileshare-name.id
}

resource "azurerm_storage_share_directory" "bootstrap-dir-content" {
  name             = "${azurerm_storage_share_directory.palo-bootstrap-shared-root-dir.name}/content"
  storage_share_id = azurerm_storage_share.palo-bootstrap-fileshare-name.id
}

resource "azurerm_storage_share_directory" "bootstrap-dir-software" {
  name             = "${azurerm_storage_share_directory.palo-bootstrap-shared-root-dir.name}/software"
  storage_share_id = azurerm_storage_share.palo-bootstrap-fileshare-name.id
}

## Main file copy

resource "azurerm_storage_share_file" "bootstrap_xml" {
  name             = "bootstrap.xml"
  storage_share_id = azurerm_storage_share.palo-bootstrap-fileshare-name.id
  path             = azurerm_storage_share_directory.bootstrap-dir-config.name
  source           = "${path.root}/palo-files/config/bootstrap.xml"
}

resource "azurerm_storage_share_file" "init_cfg" {
  name             = "init-cfg.txt"
  storage_share_id = azurerm_storage_share.palo-bootstrap-fileshare-name.id
  path             = azurerm_storage_share_directory.bootstrap-dir-config.name
  source           = "${path.root}/palo-files/config/init-cfg.txt"
}

resource "azurerm_storage_share_file" "init_lic" {
  name             = "authcodes"
  storage_share_id = azurerm_storage_share.palo-bootstrap-fileshare-name.id
  path             = azurerm_storage_share_directory.bootstrap-dir-lic.name
  source           = "${path.root}/palo-files/license/authcodes"
}