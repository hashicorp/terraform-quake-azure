# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "vm_public_ip" {
  value = "${azurerm_public_ip.test.ip_address}"
}
