# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "azurerm_resource_group" "default" {
  name     = "${var.namespace}"
  location = "${var.location}"
}
