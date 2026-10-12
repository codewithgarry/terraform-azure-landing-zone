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

  # Partial configuration. Values come from env/<environment>.backend.hcl at init time.
  backend "azurerm" {}
}

# Subscription comes from ARM_SUBSCRIPTION_ID. In CI, authentication uses OIDC (ARM_USE_OIDC=true).
provider "azurerm" {
  features {}
  storage_use_azuread = true
}
