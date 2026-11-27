output "hosted_zone_id" { value = aws_route53_zone.app.zone_id }
output "name_servers" { value = aws_route53_zone.app.name_servers }
output "application_fqdn" { value = "${var.record_name}.${var.domain_name}" }
output "primary_health_check_id" { value = aws_route53_health_check.primary.id }
