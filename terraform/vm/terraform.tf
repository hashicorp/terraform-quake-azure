# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

data "terraform_remote_state" "core" {
  backend = "azure"
  config {
    storage_account_name = "nictfremotestate"
    container_name       = "quake-core"
    key                  = "quake.terraform.tfstate"
  }
}

// Comment out these two blocks if you do not want to use DNSimple
module "dns" {
  source   = "../modules/dns"
  tld      = "demo.gs"
  a_name   = "server.quake"
  a_record = "${azurerm_public_ip.test.ip_address}"
}

output "vm_public_dns" {
  value = "${module.dns.dns_name}"
}

