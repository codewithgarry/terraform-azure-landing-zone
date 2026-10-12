org         = "acme"
environment = "prod"
location    = "centralindia"

address_space = ["10.20.0.0/16"]

subnets = {
  snet-app = {
    address_prefixes  = ["10.20.1.0/24"]
    service_endpoints = ["Microsoft.Storage"]
    nsg_rules = [
      {
        name                       = "allow-ssh-from-mgmt"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        destination_port_range     = "22"
        source_address_prefix      = "10.20.3.0/24"
        destination_address_prefix = "*"
      },
      {
        name                       = "allow-https-from-vnet"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        destination_port_range     = "443"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
      },
      {
        name                       = "deny-all-inbound"
        priority                   = 4096
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }

  snet-data = {
    address_prefixes  = ["10.20.2.0/24"]
    service_endpoints = ["Microsoft.Storage"]
    nsg_rules = [
      {
        name                       = "allow-app-to-data"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        destination_port_range     = "5432"
        source_address_prefix      = "10.20.1.0/24"
        destination_address_prefix = "*"
      }
    ]
  }

  snet-mgmt = {
    address_prefixes = ["10.20.3.0/24"]
  }
}

vm_size                  = "Standard_D2s_v5"
storage_replication_type = "ZRS"

tags = {
  owner       = "platform-team"
  cost_center = "cc-1001"
}
