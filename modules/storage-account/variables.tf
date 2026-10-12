variable "name" {
  description = "Globally unique storage account name (3-24 lowercase letters and digits)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.name))
    error_message = "Storage account names must be 3-24 lowercase letters or digits."
  }
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the storage account."
  type        = string
}

variable "replication_type" {
  description = "Replication type: LRS, ZRS, GRS or GZRS."
  type        = string
  default     = "ZRS"
}

variable "allowed_subnet_ids" {
  description = "Subnets allowed through the storage firewall. They need the Microsoft.Storage service endpoint."
  type        = list(string)
  default     = []
}

variable "allowed_ip_ranges" {
  description = "Public IPs or CIDR ranges allowed through the storage firewall."
  type        = list(string)
  default     = []
}

variable "containers" {
  description = "Private blob containers to create."
  type        = list(string)
  default     = []
}

variable "soft_delete_days" {
  description = "Retention for deleted blobs and containers."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
