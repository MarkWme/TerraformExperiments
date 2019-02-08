provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

terraform {
  backend "azurerm" {}
}

data "azurerm_key_vault_secret" "aks_ssh" {
  name      = "${var.ssh_secret_name}"
  vault_uri = "https://${var.ssh_keyvault_name}.vault.azure.net/"
}

data "azurerm_key_vault_secret" "aks_client_id" {
  name      = "${var.aks_sp_client_id}"
  vault_uri = "https://${var.aks_keyvault_name}.vault.azure.net/"
}

data "azurerm_key_vault_secret" "aks_client_secret" {
  name      = "${var.aks_sp_client_secret}"
  vault_uri = "https://${var.aks_keyvault_name}.vault.azure.net/"
}

resource "random_id" "aksname" {
  byte_length = 2
}

resource "azurerm_resource_group" "aks" {
  name     = "${var.environments["${var.environment}"]}-rg-${var.azure_regions["${var.azure_region}"]}-${var.name}-${random_id.aksname.hex}"
  location = "${var.azure_region}"

  tags = {
    deployed-by = "terraform"
    environment = "${var.environment}"
  }
}

resource "azurerm_log_analytics_workspace" "aks" {
  name                = "${var.environments["${var.environment}"]}-lg-${var.azure_regions["${var.azure_region}"]}-${var.name}-${random_id.aksname.hex}"
  location            = "${azurerm_resource_group.aks.location}"
  resource_group_name = "${azurerm_resource_group.aks.name}"
  sku                 = "Standalone"
  retention_in_days   = 30
  tags = {
    deployed-by = "terraform"
    environment = "${var.environment}"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.environments["${var.environment}"]}-ks-${var.azure_regions["${var.azure_region}"]}-${var.name}-${random_id.aksname.hex}"
  location            = "${azurerm_resource_group.aks.location}"
  resource_group_name = "${azurerm_resource_group.aks.name}"
  dns_prefix          = "${var.name}-${random_id.aksname.hex}"

  linux_profile {
    admin_username = "guvnor"

    ssh_key {
      key_data = "${data.azurerm_key_vault_secret.aks_ssh.value}"
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
    client_id     = "${data.azurerm_key_vault_secret.aks_client_id.value}"
    client_secret = "${data.azurerm_key_vault_secret.aks_client_secret.value}"
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = "${azurerm_log_analytics_workspace.aks.id}"
    }
    http_application_routing {
      enabled = true
    }
  }

  tags = {
    deployed-by = "terraform"
    environment = "${var.environment}"
  }

  kubernetes_version = "1.12.4"
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

output "http_application_routing_zone_name" {
  value = "${azurerm_kubernetes_cluster.aks.addon_profile.0.http_application_routing.0.http_application_routing_zone_name}"
}
