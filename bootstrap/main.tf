# One-time bootstrap: creates the storage account that holds remote state for every environment.
# Run locally with `az login`. Its own state stays local (chicken-and-egg).

terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.9, < 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
  storage_use_azuread = true
}

variable "location" {
  type    = string
  default = "centralindia"
}

variable "state_admin_object_id" {
  description = "Object ID of the CI service principal (or group) that reads and writes state."
  type        = string
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-tfstate"
  location = var.location
  tags     = { managed_by = "terraform", purpose = "terraform-state" }
}

resource "azurerm_storage_account" "tfstate" {
  name                            = "sttfstate${random_string.suffix.result}"
  resource_group_name             = azurerm_resource_group.tfstate.name
  location                        = azurerm_resource_group.tfstate.location
  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false # Entra ID auth only, no account keys

  blob_properties {
    versioning_enabled = true # roll back a corrupted state file
    delete_retention_policy {
      days = 30
    }
  }

  tags = azurerm_resource_group.tfstate.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

# Lets CI read and write state blobs with its Entra ID identity.
resource "azurerm_role_assignment" "state_rw" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.state_admin_object_id
}

# Prevent accidental deletion of the state storage.
resource "azurerm_management_lock" "tfstate" {
  name       = "do-not-delete-tfstate"
  scope      = azurerm_storage_account.tfstate.id
  lock_level = "CanNotDelete"
  notes      = "Holds Terraform remote state for all environments."
}

output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}
