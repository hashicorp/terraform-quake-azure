# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "master_fqdn" {
  value = "${lookup(azurerm_container_service.default.master_profile[0],"fqdn")}"
}
