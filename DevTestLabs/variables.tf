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
  default = "westeurope"
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
variable "azureRegions" {
  type = "map"

  default = {
    westeurope  = "euw"
    northeurope = "eun"
  }
}

variable "name" {
  type    = "string"
  default = "dtl"
}

