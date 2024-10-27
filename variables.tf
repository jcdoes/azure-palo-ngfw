variable "default-tags" {
  default     = {
    environment = "Development"
    application = "Palo Alto Firewall"
    department = "IT"
    cost-center = "IT1234"
    support-center = "IT Security Services"
  }
  type        = map(string)
}

variable "azure-resource-group-name" {
    type = string
    default = "azure-palo-ngfw"
}

variable "azure-region-name" {
    type = string
    default = "North Central US"
}

variable "azure-subscription-id" {
  type    = string
}

variable "azure-client-id" {
  type    = string
}

variable "azure-client-secret" {
  type    = string
}

variable "azure-tenant-id" {
  type    = string
}

## For PAN bootstrap files

# Only lower case letters and numbers
variable "palo-bootstrap-storage-account-name" {
  type    = string
  default = "palobootstrappa"
}

variable "palo-bootstrap-fileshare-name" {
  type    = string
  default = "palo-bootstrap-files-share"
}
variable "palo-bootstrap-shared-dir-name" {
  type    = string
  default = "palo-bootstrap"
}