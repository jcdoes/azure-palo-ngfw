output "filesystem-access-key" {
    value = azurerm_storage_account.palo-bootstrap-storage-account.primary_access_key
}