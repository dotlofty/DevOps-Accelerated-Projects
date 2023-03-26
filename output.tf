output "vpc_id" {
  value = module.vpc.vpc_id
}

output "Bastion_ip" {
  value = module.Bastion.public_ip
}

output "Docker_ip" {
  value = module.Docker.*.private_ip
}

output "Ansible_ip" {
  value = module.Ansible.private_ip
}

output "Sonar-pub_ip" {
  value = module.sonarqube.public_ip
}

output "Jenkins_ip" {
  value = module.Jenkins.private_ip
}

output "jenkins_elb_dns" {
  value = module.jenkins_elb.jenkins_elb_dns
}

output "alb-DNS" {
  value = module.ALB.alb-DNS
}

output "Nameservers" {
  value = module.Route53.nameservers
}