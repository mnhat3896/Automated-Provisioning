variable "resource_group_name" {
  default = "rg_monitoring"
}

variable "location" {
  default = "southeastasia"
}

variable "tag" {
  default = {
    use_for = "mornitoring"
    environment = "systemtest"
  }
}

variable "vnet_address_space" {
  default = "10.210.1.0/25"
}

variable "vnet_subnet_prefixes" {
  default = "10.210.1.0/26"
}

# VM
variable "vm_name" {
  default = "vm-monitoring"
}

variable "vm_size" {
  default = "Standard_B2s"
}

variable "vm_authen_username" {
  default = "monitoring"
}

variable "vm_os_disk_type" {
  default = "Standard_LRS"
}

variable "vm_disk_size_gb" {
  default = 32
}

variable "vm_image_sku" {
  default = "18.04-LTS"
}

variable "vm_offer" {
  default = "UbuntuServer"
}

# Keyvault

variable "keyvault_name" {
  default = "kvMonitoring"
}

variable "keyvault_secret_name" {
  default = "kv-secret-ssh-monitoring"
}
