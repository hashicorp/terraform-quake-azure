# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "name" {
  value = "${azurerm_resource_group.default.name}"
}

output "id" {
  value = "${azurerm_resource_group.default.id}"
}
