variable "key_file" {
  type        = string
  description = "SA json key"
  default     = ""
}

variable "subscription_id" {
  type        = string
  description = "a subscription id where will create resources"
}

variable "location" {
  type        = string
  description = "resource's location will be created"
}

# Network
variable "vnet_address_space" {
  type        = list(string)
  description = "The address space that is used the virtual network. You can supply more than one address space"
}

variable "vnet_subnets" {
  type = map(object({
    subnet_name    = string
    address_prefix = list(string)
  }))
  description = "subnet"
}

# Virtual machine

variable "vm_instances" {
  type = map(object({
    name     = string
    location = string
    size     = string
    zone     = string
    admin_ssh_key = object({
      username   = string
      public_key = any
    })
    os_disk = object({
      caching              = string
      storage_account_type = string
    })
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
  }))
  description = "virtual machine instance"
}
