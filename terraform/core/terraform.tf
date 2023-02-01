# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  backend "azurerm" {
    storage_account_name = "nictfremotestate"
    container_name       = "quake-core"
    key                  = "quake.terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

module "resource_group" {
  source    = "./modules/resource_group"
  
  namespace = "${var.namespace}"
  location  = "${var.location}"
}

module "container_service" {
  source              = "./modules/container-service"

  client_id           = "${var.client_id}"
  client_secret       = "${var.client_secret}"
  location            = "${var.location}"
  resource_group_name = "${module.resource_group.name}"
  name                = "${var.k8s_cluster_name}"
}
