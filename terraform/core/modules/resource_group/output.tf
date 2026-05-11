# Copyright IBM Corp. 2017, 2026

output "name" {
  value = "${azurerm_resource_group.default.name}"
}

output "id" {
  value = "${azurerm_resource_group.default.id}"
}
