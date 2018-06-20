variable "ssh-keyvault-name" {
  type = "string"
}

variable "ssh-secret-name" {
  type = "string"
}

data "azurerm_key_vault_secret" "csa" {
  name      = "${var.ssh-secret-name}"
  vault_uri = "https://${var.ssh-keyvault-name}.vault.azure.net/"
}

resource "azurerm_resource_group" "csa" {
  name     = "x-rg-euw-csa"
  location = "West Europe"

  tags {
    "Environment" = "QA Training"
  }
}

resource "azurerm_virtual_network" "csa" {
  name                = "x-vn-euw-vnet-01"
  resource_group_name = "${azurerm_resource_group.csa.name}"
  address_space       = ["10.1.0.0/16"]
  location            = "West Europe"
}

resource "azurerm_subnet" "csa" {
  name                      = "x-sn-euw-vnet-01-sn-01"
  address_prefix            = "10.1.1.0/24"
  virtual_network_name      = "${azurerm_virtual_network.csa.name}"
  resource_group_name       = "${azurerm_resource_group.csa.name}"
  network_security_group_id = "${azurerm_network_security_group.csa.id}"
}

resource "azurerm_network_security_group" "csa" {
  name                = "x-nsg-euw-nsg"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.csa.name}"
}

resource "azurerm_network_security_rule" "csa-ssh-rule" {
  name                        = "x-nsg-euw-nsg-ssh-rule"
  resource_group_name         = "${azurerm_resource_group.csa.name}"
  network_security_group_name = "${azurerm_network_security_group.csa.name}"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_public_ip" "csa" {
  name                         = "x-pip-euw-linuxvm-pip"
  location                     = "West Europe"
  resource_group_name          = "${azurerm_resource_group.csa.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "csa" {
  name                = "x-nic-euw-linxuvm-nic"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.csa.name}"

  ip_configuration = {
    name                          = "x-ip-euw-linuxvm-ip"
    subnet_id                     = "${azurerm_subnet.csa.id}"
    public_ip_address_id          = "${azurerm_public_ip.csa.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "csa" {
  name                             = "x-vl-euw-linuxvm"
  location                         = "West Europe"
  resource_group_name              = "${azurerm_resource_group.csa.name}"
  vm_size                          = "Standard_DS1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  network_interface_ids            = ["${azurerm_network_interface.csa.id}"]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "x-os-euw-linuxvm-disk0"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "x-vl-euw-linuxvmhost"
    admin_username = "guvnor"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = "${data.azurerm_key_vault_secret.csa.value}"
      path     = "/home/guvnor/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_virtual_machine_extension" "csa" {
  name                 = "x-vx-euw-linuxvm-msi"
  location             = "West Europe"
  resource_group_name  = "${azurerm_resource_group.csa.name}"
  publisher            = "Microsoft.ManagedIdentity"
  type                 = "ManagedIdentityExtensionForLinux"
  type_handler_version = "1.0"
  virtual_machine_name = "${azurerm_virtual_machine.csa.name}"
}
