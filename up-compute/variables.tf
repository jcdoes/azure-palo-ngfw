variable "azure-resource-group-name" {}
variable "azure-region-name" {}
variable "default-tags" {}

variable "palo-vn-mgmt-subnet-id" {}
variable "palo-vn-int-subnet-id" {}
variable "palo-vn-ext-subnet-id" {}

variable "vnet1-vn-subnet1-id" {}
variable "vnet1-vn-subnet2-id" {}
variable "vnet2-vn-subnet1-id" {}
variable "vnet2-vn-subnet2-id" {}

variable "win-servers-default-sg-id" {}
variable "linux-servers-default-sg-id" {}
variable "palo-mgmt-default-sg-id" {}
variable "allow-all-sg-id" {}

variable "palo-external-backend-address-pool-id" {}
variable "palo-internal-backend-address-pool-id" {}

variable "palo-bootstrap-storage-account-name" {}
variable "palo-bootstrap-fileshare-name" {}
variable "palo-bootstrap-shared-dir-name" {}
variable "filesystem-access-key" {}

variable "palo-internal-lb-01-id" {}
variable "palo-external-lb-01-id" {}