variable "ssh-keyvault-name" {
  type        = "string"
  description = "The name of the Key Vault instance where the SSH key for the Linux VM is stored. Just the name of the vault, not the URI"
}

variable "ssh-secret-name" {
  type = "string"
}

variable "subscriptionId" {
  type = "string"
}

variable "clientId" {
  type = "string"
}

variable "clientSecret" {
  type = "string"
}

variable "tenantId" {
  type = "string"
}

variable "azureRegion" {
  type    = "string"
  default = "West Europe"
}
