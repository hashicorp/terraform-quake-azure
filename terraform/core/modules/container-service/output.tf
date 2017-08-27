output "master_fqdn" {
  value = "${lookup(azurerm_container_service.default.master_profile[0],"fqdn","")}"
}

output "agents_fqdn" {
  value = "${lookup(azurerm_container_service.default.agent_pool_profile[0], "fqdn", "")}"
}
