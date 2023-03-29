#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo yum update -y
sudo yum install python3-pip -y
sudo pip3 install boto boto3 botocore 
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
sudo yum update -y 
sudo yum install git python python-devel python-pip ansible -y
sudo chown ec2-user:ec2-user /etc/ansible/hosts
sudo chown -R ec2-user:ec2-user /etc/ansible && chmod +x /etc/ansible
sudo chmod 777 /etc/ansible/hosts
sudo bash -c 'echo "StrictHostKeyChecking No" >> /etc/ssh/ssh_config'
sudo mkdir /home/ec2-user/playbooks
sudo echo "${file(dockerQAcontainer)}" >> /home/ec2-user/playbooks/dockerQAcontainer.yml
sudo echo "${file(dockerPRODcontainer)}" >> /home/ec2-user/playbooks/dockerPRODcontainer.yml 
sudo echo "[dockerQA_Server]" >> /etc/ansible/hosts
sudo echo "${dockerQA_Server_priv_ip} ansible_user=ec2-user  ansible_ssh_private_key_file=/home/ec2-user/lofty" >> /etc/ansible/hosts
sudo echo "[dockerPROD_Server]" >> /etc/ansible/hosts
sudo echo "${dockerPROD_Server_priv_ip} ansible_user=ec2-user  ansible_ssh_private_key_file=/home/ec2-user/lofty" >> /etc/ansible/hosts
sudo chmod 400 /home/ec2-user/lofty  
echo "license_key: eu01xx28fc9087c229cd6428cc55448e87b8NRAL" | sudo tee -a /etc/newrelic-infra.yml
sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo
sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
sudo yum install newrelic-infra -y --nobest
echo "${file(keypair)}" >> /home/ec2-user/lofty
sudo chown ec2-user:ec2-user /home/ec2-user/lofty
chmod 400 /home/ec2-user/lofty
sudo hostnamectl set-hostname ansible