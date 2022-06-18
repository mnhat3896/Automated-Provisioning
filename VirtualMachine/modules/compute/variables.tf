variable "location" {
  type        = string
  description = "resource's location will be created"
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

variable "resource_group_name" {
    type = string
    description = "resource group name"
}

variable "subnet_ids" {
    type = list(string)
    description = "a list of subnet id"
}

variable "tags" {
    type = map(string)
    description = "tags"
}