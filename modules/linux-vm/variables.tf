variable "name" {
  description = "VM name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the VM."
  type        = string
}

variable "subnet_id" {
  description = "Subnet for the VM's private NIC."
  type        = string
}

variable "size" {
  description = "VM size."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin user name."
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_public_key" {
  description = "SSH public key for the admin user. Password login is disabled."
  type        = string
  sensitive   = true
}

variable "os_disk_type" {
  description = "Managed disk type for the OS disk."
  type        = string
  default     = "StandardSSD_LRS"
}

variable "custom_data" {
  description = "Optional cloud-init script (plain text)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
