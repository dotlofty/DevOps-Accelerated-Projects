output "nameservers" {
  value = aws_route53_zone.myroute53.name_servers
}