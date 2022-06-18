resource "azurerm_network_interface" "nic" {
  count               = length(var.vm_instances)
  name                = "nic-${var.vm_instances[count.index].name}-${var.tags.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = length(var.subnet_ids) != 1 ? var.subnet_ids["${count.index}"] : var.subnet_ids[0]
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}


resource "azurerm_linux_virtual_machine" "vm_linuxs" {
  for_each            = var.vm_instances
  name                = "${each.value.name}-${var.tags.environment}"
  resource_group_name = var.resource_group_name
  location            = each.value.location
  size                = each.value.size
  admin_username      = each.value.admin_ssh_key.username
  network_interface_ids = [
    azurerm_network_interface.nic["${each.key}"].id
  ]

  zone = each.value.zone

  custom_data = data.template_cloudinit_config.config.rendered

  admin_ssh_key {
    username   = each.value.admin_ssh_key.username
    public_key = sensitive(file("${path.module}/resources/id_rsa.pub"))
  }

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  tags = var.tags
}
