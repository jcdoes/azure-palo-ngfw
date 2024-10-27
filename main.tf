provider "azurerm" {
  features {}
  subscription_id = var.azure-subscription-id
  client_id       = var.azure-client-id
  client_secret   = var.azure-client-secret
  tenant_id       = var.azure-tenant-id
}

## Creates required resource group.

module "up-resourcegroup" {
  source = "./up-resourcegroup"
  azure-resource-group-name = var.azure-resource-group-name
  azure-region-name = var.azure-region-name
  default-tags = var.default-tags
}

## Creates required subnets for firewall and testing subnets.

module "up-subnets" {
  source = "./up-subnets"
  azure-resource-group-name = module.up-resourcegroup.azure-resource-group-name
  azure-region-name = var.azure-region-name
  default-tags = var.default-tags
}

## Creates internal and external load balacers.

module "up-lb" {
  source = "./up-lb"
  azure-resource-group-name =  module.up-resourcegroup.azure-resource-group-name
  azure-region-name = var.azure-region-name

  default-tags = var.default-tags

  palo-vn-mgmt-subnet-id = module.up-subnets.palo-vn-mgmt-subnet-id
  palo-vn-ext-subnet-id = module.up-subnets.palo-vn-ext-subnet-id
  palo-vn-int-subnet-id = module.up-subnets.palo-vn-int-subnet-id

  vnet1-vn-subnet1-id = module.up-subnets.vnet1-vn-subnet1-id
  vnet1-vn-subnet2-id = module.up-subnets.vnet1-vn-subnet2-id

  vnet2-vn-subnet1-id = module.up-subnets.vnet2-vn-subnet1-id
  vnet2-vn-subnet2-id = module.up-subnets.vnet2-vn-subnet2-id
}

## Creates storage for bootstrap files.

module "up-storage" {
  source = "./up-storage"
  azure-resource-group-name = module.up-resourcegroup.azure-resource-group-name
  azure-region-name = var.azure-region-name
  default-tags = var.default-tags

  palo-bootstrap-storage-account-name = var.palo-bootstrap-storage-account-name
  palo-bootstrap-fileshare-name= var.palo-bootstrap-fileshare-name
  palo-bootstrap-shared-dir-name = var.palo-bootstrap-shared-dir-name
}

## Creates virtual machines for lab.

module "up-compute" {
  source = "./up-compute"
  azure-resource-group-name = module.up-resourcegroup.azure-resource-group-name
  azure-region-name = var.azure-region-name
  default-tags = var.default-tags

  palo-vn-mgmt-subnet-id = module.up-subnets.palo-vn-mgmt-subnet-id
  palo-vn-int-subnet-id = module.up-subnets.palo-vn-int-subnet-id
  palo-vn-ext-subnet-id = module.up-subnets.palo-vn-ext-subnet-id

  vnet1-vn-subnet1-id = module.up-subnets.vnet1-vn-subnet1-id
  vnet1-vn-subnet2-id = module.up-subnets.vnet1-vn-subnet2-id

  vnet2-vn-subnet1-id = module.up-subnets.vnet2-vn-subnet1-id
  vnet2-vn-subnet2-id = module.up-subnets.vnet2-vn-subnet2-id
  
  palo-mgmt-default-sg-id = module.up-subnets.palo-mgmt-default-sg-id
  win-servers-default-sg-id = module.up-subnets.win-servers-default-sg-id
  linux-servers-default-sg-id = module.up-subnets.linux-servers-default-sg-id
  allow-all-sg-id = module.up-subnets.allow-all-sg-id

  palo-bootstrap-storage-account-name = var.palo-bootstrap-storage-account-name
  palo-bootstrap-fileshare-name = var.palo-bootstrap-fileshare-name
  palo-bootstrap-shared-dir-name = var.palo-bootstrap-shared-dir-name

  palo-internal-lb-01-id = module.up-lb.palo-internal-lb-01-id
  palo-external-lb-01-id = module.up-lb.palo-internal-lb-01-id

  palo-external-backend-address-pool-id = module.up-lb.palo-external-backend-address-pool-id
  palo-internal-backend-address-pool-id = module.up-lb.palo-internal-backend-address-pool-id

  filesystem-access-key = module.up-storage.filesystem-access-key
}

