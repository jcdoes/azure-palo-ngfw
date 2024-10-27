resource "azurerm_lb" "palo-internal-lb-01" {
  name                = "palo-internal-lb-01"
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  sku = "Standard"

  frontend_ip_configuration {
    name      = "internal-firewall-frontend"
    subnet_id = var.palo-vn-int-subnet-id
  }

  tags = merge(
    var.default-tags,
    {},
  )
}

resource "azurerm_lb_backend_address_pool" "palo-internal-backend-address-pool" {
  name            = "palo-internal-backend-address-pool"
  loadbalancer_id = azurerm_lb.palo-internal-lb-01.id
}

## This is for Gateway Load Balancer

# resource "azurerm_lb" "palo-internal-lb-01" {
#   name                = "security-lb-01"
#   location            = var.azure-region-name
#   resource_group_name = var.azure-resource-group-name

#   sku = "Gateway"

#   frontend_ip_configuration {
#     name      = "firewall-inspection"
#     subnet_id = var.palo-vn-subnet2
#   }
# }

# resource "azurerm_lb_palo-internal-backend-address-pool" "palo-internal-backend-address-pool" {
#   name            = "backend"
#   loadbalancer_id = azurerm_lb.palo-internal-lb-01.id

#   tunnel_interface {
#     type       = "Internal"
#     identifier = "800"
#     port       = "2000"
#     protocol   = "VXLAN"
#   }
#   tunnel_interface {
#     type       = "External"
#     identifier = "801"
#     port       = "2001"
#     protocol   = "VXLAN"
#   }
# }

resource "azurerm_lb_probe" "palo-mgmt-probe" {
  loadbalancer_id = azurerm_lb.palo-internal-lb-01.id
  name            = "palo-mgmt-probe"
  port            = 80
}

resource "azurerm_lb_rule" "palo-internal-inbound-lb-rule" {
  loadbalancer_id                = azurerm_lb.palo-internal-lb-01.id
  name                           = "palo-internal-inbound-lb-rule"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = azurerm_lb.palo-internal-lb-01.frontend_ip_configuration[0].name
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.palo-internal-backend-address-pool.id  ]
  probe_id = azurerm_lb_probe.palo-mgmt-probe.id
}

## Public IP and Load Balancer

resource "azurerm_public_ip" "palo-pub-ip" {
  name                    = "palo-pub-ip"
  location                = var.azure-region-name
  resource_group_name     = var.azure-resource-group-name

  allocation_method       = "Static"
  sku = "Standard"

  tags = merge(
    var.default-tags,
    {},
  )
}

resource "azurerm_lb" "palo-external-lb-01" {
  name                = "palo-external-lb-01"
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  sku = "Standard"

  frontend_ip_configuration {
    name      = "palo-pub-ip"
    public_ip_address_id = azurerm_public_ip.palo-pub-ip.id
  }

  tags = merge(
    var.default-tags,
    {},
  )
}

resource "azurerm_lb_probe" "palo-mgmt-probe-pub" {
  loadbalancer_id = azurerm_lb.palo-external-lb-01.id
  name            = "palo-mgmt-probe-pub"
  port            = 80
}

resource "azurerm_lb_backend_address_pool" "palo-external-backend-address-pool" {
  name            = "palo-internal-backend-address-pool"
  loadbalancer_id = azurerm_lb.palo-external-lb-01.id
}

resource "azurerm_lb_outbound_rule" "palo-external-outbound-lb-rule" {
  name                    = "palo-external-outbound-lb-rule"
  loadbalancer_id         = azurerm_lb.palo-external-lb-01.id
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.palo-external-backend-address-pool.id

  frontend_ip_configuration {
    name = "palo-pub-ip"
  }
}

resource "azurerm_lb_rule" "palo-external-internal-lb-rule-rdp" {
  loadbalancer_id                = azurerm_lb.palo-external-lb-01.id
  name                           = "palo-external-internal-lb-rule-rdp"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "palo-pub-ip"
  disable_outbound_snat = true
  probe_id = azurerm_lb_probe.palo-mgmt-probe-pub.id
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.palo-external-backend-address-pool.id ]
}

## Routes

resource "azurerm_route_table" "palo-core-routes" {
  name                = "palo-core-routes"
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

   tags = merge(
    var.default-tags,
    {},
  )
}

resource "azurerm_route" "palo-core-routes-default" {
  name                = "default"

  resource_group_name = var.azure-resource-group-name
  route_table_name    = azurerm_route_table.palo-core-routes.name

  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_lb.palo-internal-lb-01.frontend_ip_configuration[0].private_ip_address 
}

## Route Table Associations

resource "azurerm_subnet_route_table_association" "palo-core-routes-assc-vnet1-sub1" {
  subnet_id      = var.vnet1-vn-subnet1-id
  route_table_id = azurerm_route_table.palo-core-routes.id
}

resource "azurerm_subnet_route_table_association" "palo-core-routes-assc-vnet2-sub1" {
  subnet_id      = var.vnet2-vn-subnet1-id
  route_table_id = azurerm_route_table.palo-core-routes.id
}