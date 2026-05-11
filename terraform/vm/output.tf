# Copyright IBM Corp. 2017, 2026

output "vm_public_ip" {
  value = "${azurerm_public_ip.test.ip_address}"
}
