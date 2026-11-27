resource "aws_route53_zone" "app" {
  name = var.domain_name
}

resource "aws_route53_health_check" "primary" {
  fqdn              = var.primary_alb_dns_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  request_interval  = 10
  failure_threshold = 2
  regions           = ["eu-west-1", "us-east-1", "us-west-1"]
  tags              = { Name = "primary-alb-health-check" }
}

resource "aws_route53_record" "primary" {
  zone_id        = aws_route53_zone.app.zone_id
  name           = var.record_name
  type           = "A"
  set_identifier = "primary-stockholm"
  failover_routing_policy { type = "PRIMARY" }
  health_check_id = aws_route53_health_check.primary.id
  alias {
    name                   = var.primary_alb_dns_name
    zone_id                = var.primary_alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "standby" {
  zone_id        = aws_route53_zone.app.zone_id
  name           = var.record_name
  type           = "A"
  set_identifier = "secondary-ireland"
  failover_routing_policy { type = "SECONDARY" }
  alias {
    name                   = var.standby_alb_dns_name
    zone_id                = var.standby_alb_zone_id
    evaluate_target_health = true
  }
}
