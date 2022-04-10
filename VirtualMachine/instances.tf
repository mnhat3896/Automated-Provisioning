resource "azurerm_public_ip" "pub_ip" {
  count               = length(var.vm_instances)
  name                = "publicIP-vm${count.index}-${local.common_labels.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  zones               = ["${var.vm_instances[count.index].zone}"]
  # have to be above basic to using zones
  sku               = "Standard"
  allocation_method = "Static"

  tags = local.common_labels
}
resource "azurerm_network_interface" "nic" {
  count               = length(var.vm_instances)
  name                = "nic${count.index}-${local.common_labels.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets["${count.index}"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pub_ip[count.index].id
  }

  tags = local.common_labels
}


resource "azurerm_linux_virtual_machine" "vm_linuxs" {
  for_each            = var.vm_instances
  name                = "${each.value.name}-${local.common_labels.environment}"
  resource_group_name = azurerm_resource_group.rg.name
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
    public_key = sensitive(file("./resources/id_rsa.pub"))
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

  tags = local.common_labels
}
