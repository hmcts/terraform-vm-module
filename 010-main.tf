resource "azurerm_windows_virtual_machine" "winvm" {
  count  = var.vm_type == "windows" ? 1 : 0
  name                = var.vm_name
  resource_group_name = var.vm_resource_group
  location            = var.vm_location
  size                = var.vm_size
  admin_username      = var.vm_admin_name
  admin_password      = var.vm_admin_password
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  os_disk {
    caching              = var.os_disk_type
    storage_account_type = var.os_disk_storage_account_type
  }

dynamic "storage_image_reference" {
    for_each = local.dynamic_storage_image
    content {
      # Either use a custom image
      id = var.custom_image_id != "" ? var.custom_image_id : ""

      # Or use a market place image
      publisher = var.custom_image_id != "" ? "" : var.vm_publisher_name
      offer     = var.custom_image_id != "" ? "" : var.vm_offer
      sku       = var.custom_image_id != "" ? "" : var.vm_sku
      version   = var.custom_image_id != "" ? "" : var.vm_version
    }
  }

  dynamic "boot_diagnostics" {
    for_each = local.dynamic_boot_diagnostics
    content {
      enabled     = true
      storage_uri = var.boot_storage_uri
    }
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "linvm" {
  count  = var.vm_type == "linux" ? 1 : 0
   name                = var.vm_name
  resource_group_name = var.vm_resource_group
  location            = var.vm_location
  size                = var.vm_size
  admin_username      = var.vm_admin_name
  admin_password      = var.vm_admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]


  os_disk {
    caching              = var.os_disk_type
    storage_account_type = var.os_disk_storage_account_type
  }

dynamic "storage_image_reference" {
    for_each = local.dynamic_storage_image
    content {
      # Either use a custom image
      id = var.custom_image_id != "" ? var.custom_image_id : ""

      # Or use a market place image
      publisher = var.custom_image_id != "" ? "" : var.vm_publisher_name
      offer     = var.custom_image_id != "" ? "" : var.vm_offer
      sku       = var.custom_image_id != "" ? "" : var.vm_sku
      version   = var.custom_image_id != "" ? "" : var.vm_version
    }
  }

  dynamic "boot_diagnostics" {
    for_each = local.dynamic_boot_diagnostics
    content {
      enabled     = true
      storage_uri = var.boot_storage_uri
    }
  }

  tags = var.tags
}