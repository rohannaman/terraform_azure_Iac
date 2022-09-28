locals {
  infra_env = terraform.workspace
}

resource "azurerm_virtual_network" "main_VM" {
  name                = "${var.prefix}-VM"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = local.infra_env
  }
}

resource "azurerm_subnet" "main_subnet" {
  name                 = "${var.prefix}subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main_VM.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main_network_interface" {
  name                = "${var.prefix}-NIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.prefix}IPConfig"
    subnet_id                     = azurerm_subnet.main_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
