# Copyright IBM Corp. 2017, 2026

output "master_fqdn" {
  value = "${lookup(azurerm_container_service.default.master_profile[0],"fqdn")}"
}
