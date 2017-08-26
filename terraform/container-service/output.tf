output "k8s_master" {
  value = "${azurerm_container_service.default.master_profile.fqdn}"
}

output "k8s_agents" {
  value = "${azurerm_container_service.default.agent_pool_profile.fqdn}"
}
