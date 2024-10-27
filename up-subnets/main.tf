## Security Groups

resource "azurerm_network_security_group" "win-servers-default-sg" {
  name                = "win-servers-default-sg"
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  security_rule {
    name                       = "allow-icmp"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    source_port_range = "8"
    destination_port_range = "0"
    protocol = "Icmp"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-outbound-http"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "allow-outbound-https"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "deny-internet-all-ports"
    priority                   = 103
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "allow-inbound-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  tags = merge(
    var.default-tags,
    {},
  )
}

resource "azurerm_network_security_group" "linux-servers-default-sg" {
  name                = "linux-servers-default-sg"
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  security_rule {
    name                       = "allow-icmp"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    source_port_range = "8"
    destination_port_range = "0"
    protocol = "Icmp"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-outbound-http"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "allow-outbound-https"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "deny-internet-all-ports"
    priority                   = 103
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "allow-inbound-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  tags = {
    environment = "Development"
  }
}

resource "azurerm_network_security_group" "allow-all-sg" {
  name                = "allow-all-sg"
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  security_rule {
    name                       = "allow-all-in"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    source_port_range = "*"
    destination_port_range = "*"
    protocol = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-all-out"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    source_port_range = "*"
    destination_port_range = "*"
    protocol = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  tags = merge(
    var.default-tags,
    {},
  )
}

resource "azurerm_network_security_group" "palo-mgmt-default-sg" {
  name                = "palo-mgmt-default-sg"
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  security_rule {
    name                       = "allow-icmp"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    source_port_range = "8"
    destination_port_range = "0"
    protocol = "Icmp"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-outbound-http"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "allow-outbound-https"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "deny-internet-all-ports"
    priority                   = 103
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "allow-inbound-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-inbound-https"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  tags = merge(
    var.default-tags,
    {},
  )
}

## Subnets
## This will create both the Palo subnets and some test subnets

resource "azurerm_virtual_network" "palo-vn" {
  name                = "palo-vn"
  address_space       = ["10.0.0.0/24"]
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  subnet {
    name           = "palo-vn-mgmt-subnet"
    address_prefix = "10.0.0.0/27"
  }

  subnet {
    name           = "palo-vn-int-subnet"
    address_prefix = "10.0.0.64/27"
  }

  subnet {
    name           = "palo-vn-ext-subnet"
    address_prefix = "10.0.0.128/27"
  }

  tags = merge(
    var.default-tags,
    {},
  )
}

resource "azurerm_virtual_network" "vnet1-vn" {
  name                = "vnet1-vn"
  address_space       = ["10.0.1.0/24"]
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  subnet {
    name           = "vnet1-vn-subnet-1"
    address_prefix = "10.0.1.0/25"
  }

  subnet {
    name           = "vnet1-vn-subnet-2"
    address_prefix = "10.0.1.128/25"
  }

  tags = merge(
    var.default-tags,
    {},
  )
}

resource "azurerm_virtual_network" "vnet2-vn" {
  name                = "vnet2-vn"
  address_space       = ["10.0.2.0/24"]
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  subnet {
    name           = "vnet2-subnet-1"
    address_prefix = "10.0.2.0/25"
  }

  subnet {
    name           = "vnet2-subnet-2"
    address_prefix = "10.0.2.128/25"
  }

  tags = merge(
    var.default-tags,
    {},
  )
}

## Peerings
## NOTE: Disabled due to not working. It will create the objects, but it never syncs.

# resource "azurerm_virtual_network_peering" "palo-vn-vnet1-peering" {
#   name                      = "pz-vsec-vnet1"
#   resource_group_name       = var.azure-resource-group-name
#   virtual_network_name      = azurerm_virtual_network.palo-vn.name
#   remote_virtual_network_id = azurerm_virtual_network.vnet1-vn.id
#   lifecycle  {
#     replace_triggered_by = [azurerm_virtual_network.palo-vn.address_space, azurerm_virtual_network.vnet1-vn.address_space]
#   }

# }

# resource "azurerm_virtual_network_peering" "palo-vn-vnet2-peering" {
#   name                      = "pz-vsec-vnet2"
#   resource_group_name       = var.azure-resource-group-name
#   virtual_network_name      = azurerm_virtual_network.palo-vn.name
#   remote_virtual_network_id = azurerm_virtual_network.vnet2-vn.id
#   lifecycle  {
#     replace_triggered_by = [azurerm_virtual_network.palo-vn.address_space, azurerm_virtual_network.vnet2-vn.address_space]
#   }

# }