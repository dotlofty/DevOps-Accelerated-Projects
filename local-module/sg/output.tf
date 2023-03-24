output "bastion-sg-id"{
    value = aws_security_group.dotun_Bastion_sg.id
}

output "ansible-sg-id" {
    value = aws_security_group.dotun_Ansible_sg.id
}

output "docker-sg-id" {
  value = aws_security_group.dotun_Docker_sg.id
}

output "jenkins-sg-id" {
  value = aws_security_group.dotun_Jenkins_sg.id
}

output "sonarQube-sg-id" {
  value = aws_security_group.dotun_SonarQube_sg.id
}

output "mySQL-sg-id" {
  value = aws_security_group.dotun_mySQL_sg.id
}

output "alb-sg-id" {
  value = aws_security_group.dotun_ALB_sg.id
}