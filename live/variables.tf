variable "org" {
  description = "Short organisation code used in resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{2,6}$", var.org))
    error_message = "org must be 2-6 lowercase letters or digits."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be dev or prod."
  }
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "centralindia"
}

variable "address_space" {
  description = "VNet address space."
  type        = list(string)
}

variable "subnets" {
  description = "Subnet definitions passed to the network module."
  type        = any
}

variable "deploy_vm" {
  description = "Whether to deploy the sample application VM."
  type        = bool
  default     = true
}

variable "vm_size" {
  description = "Size of the application VM."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_ssh_public_key" {
  description = "SSH public key for the VM admin user. Set TF_VAR_admin_ssh_public_key."
  type        = string
  sensitive   = true
  default     = ""
}

variable "storage_replication_type" {
  description = "Replication for the workload storage account."
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Extra tags merged into the default tags."
  type        = map(string)
  default     = {}
}
