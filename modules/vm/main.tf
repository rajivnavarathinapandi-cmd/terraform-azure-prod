resource "azurerm_network_interface" "nic" {

  count = var.vm_count

  name                = "${var.vm_name}-${count.index + 1}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {

  count = var.vm_count

  name                = "${var.vm_name}-${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F1ads_v7"

  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
resource "azurerm_network_interface_backend_address_pool_association" "lb_association" {

  count = var.vm_count

  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = var.backend_pool_id

}










