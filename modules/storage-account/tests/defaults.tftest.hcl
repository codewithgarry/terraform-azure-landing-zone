mock_provider "azurerm" {
  source = "../../tests/mocks"
}

variables {
  name                = "stunittest001"
  location            = "centralindia"
  resource_group_name = "rg-test"
  containers          = ["data"]
}

run "secure_defaults" {
  command = apply

  assert {
    condition     = azurerm_storage_account.this.network_rules[0].default_action == "Deny"
    error_message = "Storage firewall must deny by default."
  }

  assert {
    condition     = azurerm_storage_account.this.min_tls_version == "TLS1_2"
    error_message = "Minimum TLS version must be 1.2."
  }

  assert {
    condition     = azurerm_storage_account.this.allow_nested_items_to_be_public == false
    error_message = "Anonymous blob access must be disabled."
  }

  assert {
    condition     = azurerm_storage_account.this.blob_properties[0].versioning_enabled
    error_message = "Blob versioning must be enabled."
  }
}

run "rejects_invalid_name" {
  command = plan

  variables {
    name = "Invalid_Name!"
  }

  expect_failures = [var.name]
}
