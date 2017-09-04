resource "azurerm_managed_disk" "test" {
  name                 = "datadisk_existing"
  location             = "${var.location}"
  resource_group_name  = "${data.terraform_remote_state.core.resource_group_name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
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
  
  storage_image_reference {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2012-Datacenter"
      version   = "latest"
  }
  
  storage_os_disk {
    name              = "quakeosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
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
  
  os_profile {
    computer_name  = "quakeserver"
    admin_username = "quake"
    admin_password = "Password1234!"
  }

  tags {
    environment = "dev"
  }
}

data "template_file" "init" {
  template = "${file("./templates/provision_settings.json")}"

  vars {
    arm_access_key = "${var.arm_access_key}"
  }
}

resource "azurerm_virtual_machine_extension" "test" {
  name                 = "quakeserver"
  location              = "${var.location}"
  resource_group_name   = "${data.terraform_remote_state.core.resource_group_name}"
  virtual_machine_name = "${azurerm_virtual_machine.test.name}"
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = "${data.template_file.init.rendered}"

  tags {
    environment = "Production"
  }
}
