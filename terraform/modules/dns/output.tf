# Copyright IBM Corp. 2017, 2026

output "dns_name" {
  value = "${dnsimple_record.www.hostname}"
}
