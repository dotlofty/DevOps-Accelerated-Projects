output "alb-TG" {
  value = aws_lb_target_group.dotun-ALB-TG.arn
}

output "alb-DNS" {
  value = aws_lb.dotun-ALB.dns_name
}

output "alb-zone-id"{
    value = aws_lb.dotun-ALB.zone_id
}

output "alb-arn" {
  value = aws_lb.dotun-ALB.arn
}