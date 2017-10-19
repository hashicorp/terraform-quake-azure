output "dns_name" {
  value = "${dnsimple_record.www.hostname}"
}
