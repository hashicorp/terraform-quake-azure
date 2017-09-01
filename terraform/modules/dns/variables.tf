variable "tld" {
  description = "top level domain name i.e. demo.gs"
}

variable "a_name" {
  description = "new record to create, tld is automatically appended i.e. server.quake.demo.gs"
}

variable "a_record" {
  description = "ip address to point record at"
}
