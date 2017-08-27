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
