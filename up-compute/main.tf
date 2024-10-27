## Windows Server

resource "azurerm_network_interface" "windows-bastion-nic" {
  name                = "windows-bastion-nic"
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  ip_configuration {
    name                          = "windows-bastion-nic-conf"
    subnet_id                     = var.vnet1-vn-subnet1-id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "windows-bastion-nic-sg" {
  network_interface_id      = azurerm_network_interface.windows-bastion-nic.id
  network_security_group_id = var.win-servers-default-sg-id
}

resource "azurerm_windows_virtual_machine" "windows-bastion-vm" {
  name                  = "windows-bastion"
  location              = var.azure-region-name
  resource_group_name   = var.azure-resource-group-name
  network_interface_ids = [ azurerm_network_interface.windows-bastion-nic.id ]

  size                  = "Standard_DS1_v2"

  admin_username        = "paloalto"
  admin_password        = "Admin1234!"

  source_image_reference {
    publisher           = "MicrosoftWindowsServer"
    offer               = "WindowsServer"
    sku                 = "2019-Datacenter"
    version             = "latest"
  }
  
  os_disk {
    storage_account_type  = "Standard_LRS"
    caching               = "ReadWrite"
  }
  
  tags = merge(
    var.default-tags,
    {},
  )
}

## Linux Server

resource "azurerm_network_interface" "linux-bastion-nic" {
  name                = "linux-bastion-nic"
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  ip_configuration {
    name                          = "linux-bastion-ip-conf"
    subnet_id                     = var.vnet2-vn-subnet1-id
    private_ip_address_allocation = "Dynamic"
    
  }
}

resource "azurerm_network_interface_security_group_association" "linux-bastion-nic-sg" {
  network_interface_id      = azurerm_network_interface.linux-bastion-nic.id
  network_security_group_id = var.linux-servers-default-sg-id
}

resource "azurerm_linux_virtual_machine" "linux-bastio-vm" {
  name                  = "linux-bastion"
  location              = var.azure-region-name
  resource_group_name   = var.azure-resource-group-name
  network_interface_ids = [azurerm_network_interface.linux-bastion-nic.id]
  size               = "Standard_DS1_v2"

  admin_username                  = "paloalto"
  admin_password                  = "Admin1234!"

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11-backports-gen2"
    version   = "latest"
  }
  os_disk {
    storage_account_type = "Standard_LRS"
    caching           = "ReadWrite"
  }

  disable_password_authentication = false
  
  tags = merge(
    var.default-tags,
    {},
  )
}

## Palo Alto

## FW Mgmt

resource "azurerm_public_ip" "palo-fw-mgmt-pub-ip" {
  name                    = "palo-fw-mgmt-pub-ip"
  location                = var.azure-region-name
  resource_group_name     = var.azure-resource-group-name
  allocation_method       = "Static"
  sku                     = "Standard"
}

resource "azurerm_network_interface" "palo-fw-mgmt-nic" {
  name                = "palo-fw-mgmt-nic"
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  ip_configuration {
    name                          = "palo-fw-mgmt-ip-conf"
    subnet_id                     = var.palo-vn-mgmt-subnet-id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.palo-fw-mgmt-pub-ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "palo-mgmt-sec-assc" {
  network_interface_id      = azurerm_network_interface.palo-fw-mgmt-nic.id
  network_security_group_id = var.palo-mgmt-default-sg-id
}

## FW Data

resource "azurerm_network_interface" "palo-fw-int-nic" {
  name                = "palo-fw-int-nic"
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  ip_forwarding_enabled = true
  accelerated_networking_enabled = true

  ip_configuration {
    name                          = "palo-fw-int-nic-ip-conf"
    subnet_id                     = var.palo-vn-int-subnet-id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_network_interface_security_group_association" "palo-fw-int-nic-sg-assc" {
  network_interface_id      = azurerm_network_interface.palo-fw-int-nic.id
  network_security_group_id = var.allow-all-sg-id
}

resource "azurerm_network_interface" "palo-fw-ext-nic" {
  name                = "palo-fw-ext-nic"
  location            = var.azure-region-name
  resource_group_name = var.azure-resource-group-name

  ip_forwarding_enabled = true
  accelerated_networking_enabled = true

  ip_configuration {
    name                          = "palo-fw-ext-nic-ip-conf"
    subnet_id                     = var.palo-vn-ext-subnet-id
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_interface_security_group_association" "palo-fw-ext-nic-sg-assc" {
  network_interface_id      = azurerm_network_interface.palo-fw-ext-nic.id
  network_security_group_id = var.allow-all-sg-id
}

resource "azurerm_linux_virtual_machine" "panfw" {
  name                  = "fw-pan"
  location              = var.azure-region-name
  resource_group_name   = var.azure-resource-group-name

  network_interface_ids = [ 
    azurerm_network_interface.palo-fw-mgmt-nic.id,
    azurerm_network_interface.palo-fw-ext-nic.id,
    azurerm_network_interface.palo-fw-int-nic.id
  ]

  size                            = "Standard_DS3_v2"

  admin_username                  = "paloalto"
  admin_password                  = "Admin1234!"

  custom_data = base64encode("storage-account=${var.palo-bootstrap-storage-account-name},access-key=${var.filesystem-access-key},file-share=${var.palo-bootstrap-fileshare-name},share-directory=${var.palo-bootstrap-shared-dir-name}")

  source_image_reference {
    publisher = "paloaltonetworks"
    offer     = "vmseries-flex"
    sku       = "byol"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name = "byol"
    publisher = "paloaltonetworks"
    product = "vmseries-flex"
  }

  disable_password_authentication = false

  tags = merge(
    var.default-tags,
    {},
  )
}

resource "azurerm_network_interface_backend_address_pool_association" "palo-int-backend-pool-assc" {
  network_interface_id    = azurerm_network_interface.palo-fw-int-nic.id
  ip_configuration_name   = "palo-fw-int-nic-ip-conf"
  backend_address_pool_id = var.palo-internal-backend-address-pool-id
}

resource "azurerm_network_interface_backend_address_pool_association" "palo-ext-backend-pool-assc" {
  network_interface_id    = azurerm_network_interface.palo-fw-ext-nic.id
  ip_configuration_name   = "palo-fw-ext-nic-ip-conf"
  backend_address_pool_id = var.palo-external-backend-address-pool-id
}