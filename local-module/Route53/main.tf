#Create ACM Certificate
resource "aws_acm_certificate" "dotun_certificate" {
  domain_name       = var.mydomain_name
  validation_method = "DNS"
}

#get details about the manually created R53 Hosted zone
data "aws_route53_zone" "myhostedZ" {
  name         = var.mydomain_name
  private_zone = false
}

#Domain name Validation
resource "aws_route53_record" "r53record" {
  for_each = {
    for dvo in aws_acm_certificate.dotun_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.myhostedZ.zone_id
}

#Validate ACM Certificate
resource "aws_acm_certificate_validation" "acm_valid_cert" {
  certificate_arn         = aws_acm_certificate.dotun_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.r53record : record.fqdn]
}

#Record
resource "aws_route53_record" "myDomain_NS" {
  zone_id = data.aws_route53_zone.myhostedZ.zone_id
  name    = var.mydomain_name
  type    = var.myrec_type

  alias {
    name                   = var.lb_dns
    zone_id                = var.lb_zoneid
    evaluate_target_health = true
  }
}