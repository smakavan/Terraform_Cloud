# ---- resource group -----
resource "azurerm_resource_group" "rg_test" {
  name     = var.rgname
  location = var.rglocation
}


# ----- vnet create ----
resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg_test.location
  resource_group_name = azurerm_resource_group.rg_test.name
  address_space       = var.address_space
}


# ----- sub net create ----
resource "azurerm_subnet" "snet_name1" {
  name                 = var.snet_name
  resource_group_name = azurerm_resource_group.rg_test.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = var.address_prefixes_snet
}

# ----- create public IP----
resource "azurerm_public_ip" "public_ip" {
  name                = var.pip_name
  resource_group_name = azurerm_resource_group.rg_test.name
  location            = azurerm_resource_group.rg_test.location
  allocation_method   = "Static"
}


# ----- create nsg----
resource "azurerm_network_security_group" "nsg_name1" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg_test.location
  resource_group_name = azurerm_resource_group.rg_test.name

  security_rule {
    name                       = "test12345"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


# ----- create nic----
resource "azurerm_network_interface" "nic_name1" {
  name                = var.nic_name
  location            = azurerm_resource_group.rg_test.location
  resource_group_name = azurerm_resource_group.rg_test.name

  ip_configuration {
    name                          = var.ipconfig_name
    subnet_id                     = azurerm_subnet.snet_name1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id # Associate public ip to NIC
  }
}


# ---- NIC and NSG Association ------
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic_name1.id
  network_security_group_id = azurerm_network_security_group.nsg_name1.id
}


# --- Virtual Machine ------ Windows
resource "azurerm_windows_virtual_machine" "vm_name" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg_test.name
  location            = azurerm_resource_group.rg_test.location
  size                = var.vm_size
  admin_username      = var.user_name
  admin_password      = var.pass_win
  network_interface_ids = [
    azurerm_network_interface.nic_name1.id,
  ]
  patch_mode = "AutomaticByPlatform"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition-hotpatch"
    version   = "latest"
  }
}
