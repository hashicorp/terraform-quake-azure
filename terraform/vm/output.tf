output "vm_public_ip" {
  value = "${azurerm_public_ip.test.ip_address}"
}
