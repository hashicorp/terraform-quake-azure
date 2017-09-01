data "terraform_remote_state" "core" {
  backend = "azure"
  config {
    storage_account_name = "nictfremotestate"
    container_name       = "quake-core"
    key                  = "quake.terraform.tfstate"
  }
}

provider "kubernetes" {
  host       = "https://${data.terraform_remote_state.core.k8s_master}"
}

// Comment out these two blocks if you do not want to use AWS DNS
module "aws_dns" {
  source   = "../modules/dns"
  tld      = "demo.gs"
  a_name   = "client.quake"
  a_record = "${kubernetes_service.quake.load_balancer_ingress.0.ip}"
}

output "service_public_dns" {
  value = "${module.aws_dns.dns_name}"
}
