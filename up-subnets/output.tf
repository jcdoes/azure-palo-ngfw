output "palo-vn-mgmt-subnet-id" {
  value = azurerm_virtual_network.palo-vn.subnet.*.id[0]
}

output "palo-vn-ext-subnet-id" {
  value = azurerm_virtual_network.palo-vn.subnet.*.id[1]
}

output "palo-vn-int-subnet-id" {
  value = azurerm_virtual_network.palo-vn.subnet.*.id[2]
}

output "vnet1-vn-subnet1-id" {
  value = azurerm_virtual_network.vnet1-vn.subnet.*.id[0]
}

output "vnet1-vn-subnet2-id" {
  value = azurerm_virtual_network.vnet1-vn.subnet.*.id[1]
}

output "vnet2-vn-subnet1-id" {
  value = azurerm_virtual_network.vnet2-vn.subnet.*.id[0]
}

output "vnet2-vn-subnet2-id" {
  value = azurerm_virtual_network.vnet2-vn.subnet.*.id[1]
}

output "linux-servers-default-sg-id" {
  value = azurerm_network_security_group.linux-servers-default-sg.id
}

output "win-servers-default-sg-id" {
  value = azurerm_network_security_group.win-servers-default-sg.id
}

output "palo-mgmt-default-sg-id" {
  value = azurerm_network_security_group.palo-mgmt-default-sg.id
}

output "allow-all-sg-id" {
  value = azurerm_network_security_group.allow-all-sg.id
}

