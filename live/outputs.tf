output "vnet_id" {
  description = "Virtual network ID."
  value       = module.network.vnet_id
}

output "subnet_ids" {
  description = "Subnet IDs by name."
  value       = module.network.subnet_ids
}

output "app_vm_private_ip" {
  description = "Private IP of the application VM."
  value       = var.deploy_vm ? module.app_vm[0].private_ip : null
}

output "storage_account_name" {
  description = "Workload storage account name."
  value       = module.storage.name
}
