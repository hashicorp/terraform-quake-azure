# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "dns_name" {
  value = "${dnsimple_record.www.hostname}"
}
