#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "${file(keypair)}" >> /home/ec2-user/lofty
sudo chown ec2-user:ec2-user /home/ec2-user/lofty
chmod 400 /home/ec2-user/lofty
sudo hostnamectl set-hostname bastion