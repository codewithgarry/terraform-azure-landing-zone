# Module: network

Creates a virtual network, its subnets and **one network security group per subnet**, with rules defined as data.

```hcl
module "network" {
  source              = "../modules/network"
  name                = "vnet-acme-dev"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.network.name
  address_space       = ["10.10.0.0/16"]

  subnets = {
    snet-app = {
      address_prefixes  = ["10.10.1.0/24"]
      service_endpoints = ["Microsoft.Storage"]
      nsg_rules = [{
        name                       = "allow-ssh-from-mgmt"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        destination_port_range     = "22"
        source_address_prefix      = "10.10.3.0/24"
        destination_address_prefix = "*"
      }]
    }
  }
}
```

| Output | Description |
|---|---|
| `vnet_id` / `vnet_name` | The virtual network |
| `subnet_ids` | Map of subnet name to ID |
| `nsg_ids` | Map of subnet name to NSG ID |
