output "palo-internal-backend-address-pool-id" {
    value = azurerm_lb_backend_address_pool.palo-internal-backend-address-pool.id
}

output "palo-external-backend-address-pool-id" {
    value = azurerm_lb_backend_address_pool.palo-external-backend-address-pool.id
}

output "palo-internal-lb-01-id" {
    value = azurerm_lb.palo-internal-lb-01.frontend_ip_configuration[0].id
}

output "palo-external-lb-01-id" {
    value = azurerm_lb.palo-internal-lb-01.frontend_ip_configuration[0].id
}