provider "aws" {}

data "aws_route53_zone" "selected" {
  name         = "${var.tld}."
  private_zone = false
}

resource "aws_route53_record" "a" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.a_name}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${var.a_record}"]
}
