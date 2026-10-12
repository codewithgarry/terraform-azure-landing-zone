variable "name" {
  description = "Virtual network name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the network resources."
  type        = string
}

variable "address_space" {
  description = "Address space of the virtual network."
  type        = list(string)
}

variable "subnets" {
  description = "Subnets keyed by name. Each subnet gets its own NSG with the listed rules."
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    nsg_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string, "*")
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), [])
  }))
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
