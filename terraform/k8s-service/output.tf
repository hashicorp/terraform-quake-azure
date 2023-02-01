# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "quake_client" {
  value = "${kubernetes_service.quake.load_balancer_ingress.0.ip}"
}

