variable "subscription_id" {
  type = "string"
}

variable "client_id" {
  type = "string"
}

variable "client_secret" {
  type = "string"
}

variable "tenant_id" {
  type = "string"
}

variable "azure_regions" {
  type = "map"

  default = {
    westeurope  = "euw"
    northeurope = "eun"
  }
}

variable "azure_region" {
  type    = "string"
  default = "westeurope"
}

variable "name" {
  type    = "string"
  default = "aks"
}

variable "environment" {
  type    = "string"
  default = "temp"
}

variable "environments" {
  type = "map"

  default = {
    development = "d"
    test        = "t"
    production  = "p"
    temp        = "x"
  }
}

variable "ssh_keyvault_name" {
  type        = "string"
  description = "The name of the Key Vault instance where the SSH key for the Linux VM is stored. Just the name of the vault, not the URI"
}

variable "ssh_secret_name" {
  type = "string"
}

variable "aks_keyvault_name" {
  type = "string"
}

variable "aks_sp_client_id" {
  type = "string"
}

variable "aks_sp_client_secret" {
  type = "string"
}
