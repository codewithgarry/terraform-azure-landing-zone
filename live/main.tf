locals {
  prefix = "${var.org}-${var.environment}"

  tags = merge(var.tags, {
    environment = var.environment
    managed_by  = "terraform"
    repository  = "terraform-azure-landing-zone"
  })
}

# ---------- Resource groups: network and workload are separated for RBAC and lifecycle ----------
resource "azurerm_resource_group" "network" {
  name     = "rg-${local.prefix}-network"
  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "workload" {
  name     = "rg-${local.prefix}-app"
  location = var.location
  tags     = local.tags
}

# ---------- Network ----------
module "network" {
  source = "../modules/network"

  name                = "vnet-${local.prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = var.address_space
  subnets             = var.subnets
  tags                = local.tags
}

# ---------- Compute ----------
module "app_vm" {
  source = "../modules/linux-vm"
  count  = var.deploy_vm ? 1 : 0

  name                 = "vm-${local.prefix}-app01"
  location             = var.location
  resource_group_name  = azurerm_resource_group.workload.name
  subnet_id            = module.network.subnet_ids["snet-app"]
  size                 = var.vm_size
  admin_ssh_public_key = var.admin_ssh_public_key
  tags                 = local.tags

  custom_data = <<-CLOUDINIT
    #cloud-config
    package_update: true
    packages: [nginx]
  CLOUDINIT
}

# ---------- Storage ----------
resource "random_string" "storage_suffix" {
  length  = 6
  upper   = false
  special = false
}

module "storage" {
  source = "../modules/storage-account"

  name                = "st${var.org}${var.environment}${random_string.storage_suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.workload.name
  replication_type    = var.storage_replication_type
  allowed_subnet_ids  = [module.network.subnet_ids["snet-app"]]
  containers          = ["app-data", "backups"]
  tags                = local.tags
}

# The VM reads and writes app data with its managed identity, no keys involved.
resource "azurerm_role_assignment" "vm_blob_access" {
  count = var.deploy_vm ? 1 : 0

  scope                = module.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.app_vm[0].principal_id
}
