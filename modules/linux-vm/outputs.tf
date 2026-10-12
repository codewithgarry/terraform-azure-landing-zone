output "id" {
  description = "VM resource ID."
  value       = azurerm_linux_virtual_machine.this.id
}

output "private_ip" {
  description = "Private IP address of the VM."
  value       = azurerm_network_interface.this.private_ip_address
}

output "principal_id" {
  description = "Object ID of the VM's system-assigned managed identity."
  value       = azurerm_linux_virtual_machine.this.identity[0].principal_id
}
