# Copyright IBM Corp. 2017, 2026

resource "azurerm_resource_group" "default" {
  name     = "${var.namespace}"
  location = "${var.location}"
}
