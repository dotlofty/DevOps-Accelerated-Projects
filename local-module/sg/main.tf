resource "aws_security_group" "dotun_Bastion_sg" {
  name        = "${var.name}-Bastion_sg"
  description = "Allow inbound traffic"
  vpc_id      = var.dotunvpc_id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.ssh_port
    to_port          = var.ssh_port
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }

  ingress {
    description      = "Allow inbound traffic"
    from_port        = var.http_port
    to_port          = var.http_port
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-Bastion_sg"
  }
}

resource "aws_security_group" "dotun_Ansible_sg" {
  name        = "${var.name}-Ansible_sg"
  description = "Allow inbound traffic"
  vpc_id      = var.dotunvpc_id

  ingress {
    description      = "ssh access"
    from_port        = var.ssh_port
    to_port          = var.ssh_port
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }

  ingress {
    description      = "Allow inbound traffic"
    from_port        = var.http_port
    to_port          = var.http_port
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ansible_sg"
  }
}

resource "aws_security_group" "dotun_Docker_sg" {
  name        = "${var.name}-Docker_sg"
  description = "Allow inbound traffic"
  vpc_id      = var.dotunvpc_id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.ssh_port
    to_port          = var.ssh_port
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }

  ingress {
    description      = "Allow inbound traffic"
    from_port        = var.http_port
    to_port          = var.http_port
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }
  ingress {
    description      = "Allow proxy access"
    from_port        = var.proxy_port1
    to_port          = var.proxy_port1
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }
  ingress {
    description      = "Allow proxy access"
    from_port        = var.proxy_port2
    to_port          = var.proxy_port2
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-Docker_sg"
  }
}

resource "aws_security_group" "dotun_Jenkins_sg" {
  name        = "${var.name}-Jenkins_sg"
  description = "Allow inbound traffic"
  vpc_id      = var.dotunvpc_id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.ssh_port
    to_port          = var.ssh_port
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }

  ingress {
    description      = "Allow inbound traffic"
    from_port        = var.http_port
    to_port          = var.http_port
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }
  ingress {
    description      = "Allow proxy access"
    from_port        = var.proxy_port1
    to_port          = var.proxy_port1
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-Jenkins_sg"
  }
}

resource "aws_security_group" "dotun_SonarQube_sg" {
  name        = "${var.name}-SonarQube_sg"
  description = "Allow inbound traffic"
  vpc_id      = var.dotunvpc_id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.ssh_port
    to_port          = var.ssh_port
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }

  ingress {
    description      = "Allow inbound traffic"
    from_port        = var.http_port
    to_port          = var.http_port
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }
  ingress {
    description      = "Allow proxy access"
    from_port        = var.proxy_port2
    to_port          = var.proxy_port2
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-SonarQube_sg"
  }
}

resource "aws_security_group" "dotun_ALB_sg" {
  name        = "${var.name}-ALB_sg"
  description = "Allow inbound traffic"
  vpc_id      = var.dotunvpc_id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.ssh_port
    to_port          = var.ssh_port
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }

  ingress {
    description      = "Allow inbound traffic"
    from_port        = var.http_port
    to_port          = var.http_port
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }
  ingress {
    description      = "Allow proxy access"
    from_port        = var.proxy_port1
    to_port          = var.proxy_port1
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ALB_sg"
  }
}

resource "aws_security_group" "dotun_mySQL_sg" {
  name        = "${var.name}-mySQL_sg"
  description = "Allow inbound traffic"
  vpc_id      = var.dotunvpc_id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.mySQL_port
    to_port          = var.mySQL_port
    protocol         = "tcp"
    cidr_blocks      = [var.all_access]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-mySQL_sg"
  }
}