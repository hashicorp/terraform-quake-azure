# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "dnsimple" {
}

# Create a record
resource "dnsimple_record" "www" {
  domain = "${var.tld}"
  name   = "${var.a_name}"
  value  = "${var.a_record}"
  type   = "A"
  ttl    = 360
}
