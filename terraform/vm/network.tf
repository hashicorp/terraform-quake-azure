resource "azurerm_virtual_network" "test" {
  name                = "acctvn"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${data.terraform_remote_state.core.resource_group_name}"
}

resource "azurerm_network_security_group" "web" {
  name                = "quakesg"
  location            = "${var.location}"
  resource_group_name = "${data.terraform_remote_state.core.resource_group_name}"
  
  security_rule {
    name                       = "quakeserver_ib"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "quakeserver_ob"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet" "test" {
  name                 = "acctsub"
  resource_group_name  = "${data.terraform_remote_state.core.resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "test" {
  name                      = "acctni"
  location                  = "${var.location}"
  resource_group_name       = "${data.terraform_remote_state.core.resource_group_name}"
  network_security_group_id = "${azurerm_network_security_group.web.id}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.test.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.test.id}"
  }
}

resource "azurerm_public_ip" "test" {
  name                         = "nictestrg"
  location                     = "${var.location}"
  resource_group_name          = "${data.terraform_remote_state.core.resource_group_name}"
  public_ip_address_allocation = "static"

  tags {
    environment = "Production"
  }
}
