#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo yum update -y
sudo yum install wget vim -y
sudo bash -c 'echo "vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096" >> /etc/sysctl.conf'
sudo bash -c 'echo "sonarqube   -   nofile   65536
sonarqube   -   nproc    4096" >> /etc/security/limits.conf'
sudo yum install java-11-openjdk-devel -y
sudo dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo dnf -qy module disable postgresql
sudo dnf -y install postgresql13 postgresql13-server
sudo /usr/pgsql-13/bin/postgresql-13-setup initdb
sudo systemctl enable --now postgresql-13
sudo su -c 'createuser sonar' postgres
sudo su -c "psql -c \"ALTER USER postgres WITH PASSWORD 'Str0ngDBP@ssword'\"" postgres
sudo su -c "psql -c \"ALTER USER sonar WITH ENCRYPTED PASSWORD 'StrongPassword'\"" postgres
sudo su -c "psql -c \"CREATE DATABASE sonar_db OWNER sonar\"" postgres
sudo su -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE sonar_db to sonar\"" postgres
sudo bash -c "echo \"listen_addresses = '*'\" >> /var/lib/pgsql/13/data/postgresql.conf"
sudo bash -c 'echo "host    all             all             0.0.0.0/0               md5" >> /var/lib/pgsql/13/data/pg_hba.conf'
sudo systemctl restart postgresql-13
cd /opt
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.1.0.47736.zip
sudo yum -y install unzip
sudo unzip sonarqube-*.zip
sudo mv sonarqube-*/ sonarqube
sudo rm sonarqube-*.zip
sudo groupadd sonar
sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar
sudo chown -R sonar:sonar /opt/sonarqube
sudo bash -c 'echo "sonar.jdbc.username=sonar
sonar.jdbc.password=StrongPassword
sonar.jdbc.url=jdbc:postgresql://localhost/sonar_db
sonar.web.javaOpts=-Xmx512m -Xms128m -XX:+HeapDumpOnOutOfMemoryError
sonar.search.javaOpts=-Xmx512m -Xms512m -XX:MaxDirectMemorySize=256m -XX:+HeapDumpOnOutOfMemoryError
sonar.path.data=data
sonar.path.temp=temp" >> /opt/sonarqube/conf/sonar.properties'
sudo bash -c 'echo "wrapper.java.command=/usr/bin/java" >> /opt/sonarqube/conf/wrapper.conf'
sudo touch /etc/systemd/system/sonarqube.service
sudo bash -c 'echo "[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
ExecReload=/opt/sonarqube/bin/linux-x86-64/sonar.sh restart

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096


[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/sonarqube.service'
sudo systemctl daemon-reload
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sudo sysctl --system
sudo systemctl restart sonarqube.service
sudo systemctl enable sonarqube.service