output "quake_client" {
  value = "${kubernetes_service.quake.load_balancer_ingress.0.ip}"
}

output "vm_public_dns" {
  value = "${aws_route53_record.a.name}"
}
