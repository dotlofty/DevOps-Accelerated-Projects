output "jenkins_elb_dns" {
  value = aws_elb.jenkins_elb.dns_name
}