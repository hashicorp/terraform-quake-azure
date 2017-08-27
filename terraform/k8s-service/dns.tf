provider "aws" {}

data "aws_route53_zone" "selected" {
  name         = "demo.gs."
  private_zone = false
}

resource "aws_route53_record" "a" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "client.quake.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${kubernetes_service.quake.load_balancer_ingress.0.ip}"]
}
