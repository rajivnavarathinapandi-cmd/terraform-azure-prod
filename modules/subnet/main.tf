resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
}
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = var.nsg_id != null ? { assoc = var.nsg_id } : {}

  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = each.value
}
