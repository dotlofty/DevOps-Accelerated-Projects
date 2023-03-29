output "nameservers" {
  value = data.aws_route53_zone.myhostedZ.name_servers
}