##############
## DEV VARS ##
##############

location = "southeastasia"
# SA json key
key_file        = "./resources/key-dev-be.json"

vnet_address_space = ["10.0.0.0/16"]
vnet_subnets = {
  0 = {
    subnet_name    = "subnet1"
    address_prefix = ["10.0.1.0/24"]
  }
  1 = {
    subnet_name    = "subnet2"
    address_prefix = ["10.0.2.0/24"]
  }
}


vm_instances = {
  0 = {
    name     = "vmlinux1"
    location = "southeastasia"
    size     = "Standard_B1s"
    zone     = 1
    admin_ssh_key = {
      username   = "adminlinux1"
      public_key = ""
    }
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
  }
  1 = {
    name     = "vmlinux2"
    location = "southeastasia"
    size     = "Standard_B1s"
    zone     = 2
    admin_ssh_key = {
      username   = "adminlinux2"
      public_key = ""
    }
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
  }
}
