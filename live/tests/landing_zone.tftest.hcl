# Unit tests with mocked providers. Nothing is created in Azure.
# Run: terraform test -var-file=env/dev.tfvars   (or prod.tfvars)

mock_provider "azurerm" {
  source = "../tests/mocks"
}

variables {
  admin_ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICArM6iPoM1YRAlXochqCEDbxXwZ2HVDaOiLueK2A5QM terraform-test-only" # test-only key, never used for real access
}

run "names_follow_convention" {
  command = apply

  assert {
    condition     = azurerm_resource_group.network.name == "rg-${var.org}-${var.environment}-network"
    error_message = "Network resource group name does not follow rg-<org>-<env>-network."
  }

  assert {
    condition     = module.network.vnet_name == "vnet-${var.org}-${var.environment}"
    error_message = "VNet name does not follow vnet-<org>-<env>."
  }
}

run "every_subnet_has_an_nsg" {
  command = apply

  assert {
    condition     = length(module.network.nsg_ids) == length(var.subnets)
    error_message = "Each subnet must have its own NSG."
  }
}

run "storage_is_locked_down" {
  command = apply

  assert {
    condition     = module.storage.name == lower(module.storage.name) && length(module.storage.name) <= 24
    error_message = "Storage account name must be lowercase and at most 24 characters."
  }
}

run "vm_is_optional" {
  command = apply

  variables {
    deploy_vm = false
  }

  assert {
    condition     = output.app_vm_private_ip == null
    error_message = "No VM should be deployed when deploy_vm = false."
  }
}
