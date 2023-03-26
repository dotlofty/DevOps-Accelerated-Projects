module "vpc" {
  source                = "terraform-aws-modules/vpc/aws"
  name                  = var.vpc_name
  cidr                  = var.vpc_cidr
  azs                   = [var.az1, var.az2]
  private_subnets       = [var.priv_subnet1, var.priv_subnet2]
  public_subnets        = [var.pub_subnet1, var.pub_subnet2]
  enable_nat_gateway    = true
  single_nat_gateway    = false
  one_nat_gateway_per_az = true

  tags = {
    Terraform = "true"
    Environment = "dev"
    Name = "${var.name}-vpc"
  }
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  key_name   = var.key
  public_key = file("~/keypairs/lofty.pub")
}

module "sg" {
  source = "./local-module/sg"
  dotunvpc_id = module.vpc.vpc_id
}

module "Bastion" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${var.name}-Bastion"
  ami                    = var.ec2-ami
  instance_type          = var.instancetype
  key_name               = module.key_pair.key_pair_name
  vpc_security_group_ids = [module.sg.bastion-sg-id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data              = templatefile("./User_data/bastion.sh",
    {
      keypair = "~/keypairs/lofty"
    }
  )

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "${var.name}-Bastion"
  }
}

module "Ansible" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${var.name}-Ansible"
  ami                    = var.ec2-ami
  instance_type          = var.instancetype
  key_name               = module.key_pair.key_pair_name
  vpc_security_group_ids = [module.sg.ansible-sg-id]
  subnet_id              = module.vpc.private_subnets[0]
    user_data = templatefile("./User_data/ansible.sh",
    {
      dockerQAcontainer = "./playbooks/dockerQAcontainer.yml",
      dockerPRODcontainer = "./playbooks/dockerPRODcontainer.yml",
      dockerQA_Server_priv_ip = module.Docker[0].private_ip,
      dockerPROD_Server_priv_ip = module.Docker[1].private_ip,
      keypair = "~/keypairs/lofty"  
    }
  )

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "${var.name}-Ansible"
  }
}

module "Docker" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${var.name}-Docker"
  ami                    = var.ec2-ami
  instance_type          = var.instancetype
  key_name               = module.key_pair.key_pair_name
  vpc_security_group_ids = [module.sg.docker-sg-id]
  subnet_id              = module.vpc.private_subnets[0]
  count                     = 2
  user_data = file("./User_data/docker.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "${var.docker_name}${count.index}"
  }
}

module "Jenkins" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${var.name}-Jenkins"
  ami                    = var.ec2-ami
  instance_type          = var.instancetype
  key_name               = module.key_pair.key_pair_name
  vpc_security_group_ids = [module.sg.jenkins-sg-id]
  subnet_id              = module.vpc.private_subnets[0]
  user_data = templatefile("./User_data/jenkins.sh",
   {
    keypair = "~/keypairs/lofty"
   }
  ) 
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "${var.name}-Jenkins"
  }
}

module "jenkins_elb" {
  source = "./local-module/jenkins_elb"
  subnet_id1 = module.vpc.public_subnets[0]
  subnet_id2 = module.vpc.public_subnets[1]
  security_id = module.sg.alb-sg-id
  jenkins_id = module.Jenkins.id
}

module "sonarqube" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${var.name}-sonar"
  ami                    = var.ec2-ami
  instance_type          = var.instancetype
  key_name               = module.key_pair.key_pair_name
  vpc_security_group_ids = [module.sg.sonarQube-sg-id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data = file("./User_data/sonar.sh")
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "${var.name}-sonar"
  }
}

module "ALB" {
  source = "./local-module/ALB"
  ALB_security = module.sg.alb-sg-id
  ALB-subnet1 = module.vpc.public_subnets[0]
  ALB-subnet2 = module.vpc.public_subnets[1]
  vpc_name = module.vpc.vpc_id
  Target_EC2 = module.Docker[1].id
}

# module "ASG" {
#   source = "./local-module/ASG"
#   vpc-subnet1 = module.vpc.public_subnets[0]
#   vpc-subnet2 = module.vpc.public_subnets[1]
#   alb-arn = module.ALB.alb-arn
#   ASG-sg = module.sg.docker-sg-id
#   key_pair = module.key_pair.key_pair_name
#   dockerPROD_EC2 = module.Docker[1].id
# }

module "Route53" {
  source = "./local-module/Route53"
  lb_dns = module.ALB.alb-DNS
  lb_zoneid = module.ALB.alb-zone-id
}