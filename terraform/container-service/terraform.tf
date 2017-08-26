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
    key                  = "prod.terraform.tfstate"
  }
}

resource "azurerm_container_service" "default" {
  name                   = "quakekube"
  location               = "${var.location}"
  resource_group_name    = "${data.terraform_remote_state.core.resource_group_name}"
  orchestration_platform = "Kubernetes"

  master_profile {
    count      = 1
    dns_prefix = "quakeserver"
  }

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = "${file("~/.ssh/yubi.pub")}"
    }
  }

  agent_pool_profile {
    name       = "default"
    count      = 1
    dns_prefix = "quakekubeagent"
    vm_size    = "Standard_A0"
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  diagnostics_profile {
    enabled = false
  }

  tags {
    Environment = "dev"
  }
}
