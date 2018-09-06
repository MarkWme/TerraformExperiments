provider "azurerm" {
  subscription_id = "${var.subscriptionId}"
  client_id       = "${var.clientId}"
  client_secret   = "${var.clientSecret}"
  tenant_id       = "${var.tenantId}"
}

terraform {
  backend "azurerm" {}
}

data "azurerm_key_vault_secret" "aks-ssh" {
  name      = "${var.ssh-secret-name}"
  vault_uri = "https://${var.ssh-keyvault-name}.vault.azure.net/"
}

data "azurerm_key_vault_secret" "aks-client-id" {
  name      = "${var.aks-sp-clientId}"
  vault_uri = "https://${var.aks-keyvault-name}.vault.azure.net/"
}

data "azurerm_key_vault_secret" "aks-client-secret" {
  name      = "${var.aks-sp-clientSecret}"
  vault_uri = "https://${var.aks-keyvault-name}.vault.azure.net/"
}

resource "random_id" "aksname" {
  byte_length = 2
}

resource "azurerm_resource_group" "aks" {
  name     = "${var.environments["${var.environment}"]}-rg-${var.azureRegions["${var.azureRegion}"]}-${var.name}-${random_id.aksname.hex}"
  location = "${var.azureRegion}"

  tags = {
    deployed-by = "terraform"
    environment = "${var.environment}"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.environments["${var.environment}"]}-ks-${var.azureRegions["${var.azureRegion}"]}-${var.name}-${random_id.aksname.hex}"
  location            = "${azurerm_resource_group.aks.location}"
  resource_group_name = "${azurerm_resource_group.aks.name}"
  dns_prefix          = "${var.name}-${random_id.aksname.hex}"

  linux_profile {
    admin_username = "guvnor"

    ssh_key {
      key_data = "${data.azurerm_key_vault_secret.aks-ssh.value}"
    }
  }

  agent_pool_profile {
    name            = "apool"
    count           = 3
    vm_size         = "Standard_B2ms"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${data.azurerm_key_vault_secret.aks-client-id.value}"
    client_secret = "${data.azurerm_key_vault_secret.aks-client-secret.value}"
  }

  tags = {
    deployed-by = "terraform"
    environment = "${var.environment}"
  }

  kubernetes_version = "1.11.2"
}

output "id" {
  value = "${azurerm_kubernetes_cluster.aks.id}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config_raw}"
}

output "client_key" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.client_key}"
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.host}"
}
