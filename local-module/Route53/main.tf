#Route 53 
resource "aws_route53_zone" "myroute53" {
  name = var.mydomain_name 
  force_destroy = true
} 

#Record
resource "aws_route53_record" "myDomain_NS" {
  zone_id = aws_route53_zone.myroute53.zone_id
  name    = var.mydomain_name
  type    = var.myrec_type

  alias {
    name                   = var.lb_dns
    zone_id                = var.lb_zoneid
    evaluate_target_health = true
  }
}