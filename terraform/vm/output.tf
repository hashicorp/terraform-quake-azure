output "vm_public_ip" {
  value = "${azurerm_public_ip.test.ip_address}"
}

output "vm_public_dns" {
  value = "${aws_route53_record.a.name}"
}
