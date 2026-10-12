# Realistic IDs so the azurerm provider's ID validation passes under mocks.
mock_resource "azurerm_resource_group" {
  defaults = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock" }
}
mock_resource "azurerm_virtual_network" {
  defaults = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/virtualNetworks/vnet-mock" }
}
mock_resource "azurerm_subnet" {
  defaults = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/virtualNetworks/vnet-mock/subnets/snet-mock" }
}
mock_resource "azurerm_network_security_group" {
  defaults = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/networkSecurityGroups/nsg-mock" }
}
mock_resource "azurerm_network_interface" {
  defaults = {
    id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/networkInterfaces/nic-mock"
    private_ip_address = "10.10.1.4"
  }
}
mock_resource "azurerm_linux_virtual_machine" {
  defaults = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Compute/virtualMachines/vm-mock" }
}
mock_resource "azurerm_storage_account" {
  defaults = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Storage/storageAccounts/stmock" }
}
