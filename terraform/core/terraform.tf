terraform {
  backend "azure" {
    storage_account_name = "nictfremotestate"
    container_name       = "quake-core"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "default" {
  name     = "${var.namespace}"
  location = "${var.location}"
}
