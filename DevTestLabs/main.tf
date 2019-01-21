provider "azurerm" {
  subscription_id = "${var.subscriptionId}"
  client_id       = "${var.clientId}"
  client_secret   = "${var.clientSecret}"
  tenant_id       = "${var.tenantId}"
}

terraform {
  backend "azurerm" {}
}

resource "random_id" "labname" {
  byte_length = 2
}
resource "azurerm_resource_group" "labs" {
  name     = "${var.environments["${var.environment}"]}-rg-${var.azureRegions["${var.azureRegion}"]}-${var.name}-${random_id.labname.hex}"
  location = "${var.azureRegion}"
  tags = {
    deployed-by = "terraform"
    environment = "${var.environment}"
  }
}

resource "azurerm_dev_test_lab" "labs" {
  name = "${var.environments["${var.environment}"]}-dt-${var.azureRegions["${var.azureRegion}"]}-${var.name}-${random_id.labname.hex}"
  location = "${var.azureRegion}"
  resource_group_name = "${azurerm_resource_group.labs.name}"
  tags = {
    deployed-by = "terraform"
    environment = "${var.environment}"
  }  
}

resource "azurerm_dev_test_virtual_network" "labs" {
  name                = "${var.environments["${var.environment}"]}-vn-${var.azureRegions["${var.azureRegion}"]}-${var.name}-${random_id.labname.hex}"
  lab_name            = "${azurerm_dev_test_lab.labs.name}"
  resource_group_name = "${azurerm_resource_group.labs.name}"

  subnet {
    use_public_ip_address           = "Allow"
    use_in_virtual_machine_creation = "Allow"
  }
}
