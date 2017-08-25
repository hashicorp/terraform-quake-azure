resource "azurerm_managed_disk" "test" {
  name                 = "datadisk_existing"
  location             = "${var.location}"
  resource_group_name  = "${data.terraform_remote_state.core.resource_group_name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

resource "azurerm_managed_disk" "os" {
  name                 = "osdisk_existing"
  location             = "${var.location}"
  resource_group_name  = "${data.terraform_remote_state.core.resource_group_name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Copy"
  disk_size_gb         = "127"
  source_resource_id   = "${var.image_uri}"
  os_type              = "Windows"
}

resource "azurerm_virtual_machine" "test" {
  name                  = "acctvm"
  location              = "${var.location}"
  resource_group_name   = "${data.terraform_remote_state.core.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.test.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true
  
  os_profile_windows_config {}
  
  storage_os_disk {
    name            = "${azurerm_managed_disk.os.name}"
    managed_disk_id = "${azurerm_managed_disk.os.id}"
    create_option   = "Attach"
    os_type         = "windows"
  }

  # Optional data disks
  storage_data_disk {
    name              = "datadisk_new"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.test.name}"
    managed_disk_id = "${azurerm_managed_disk.test.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.test.disk_size_gb}"
  }

  tags {
    environment = "dev"
  }
}
