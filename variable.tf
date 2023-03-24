variable "name" {
  default = "dotun"
}

variable "ec2-ami" {
  default = "ami-05c96317a6278cfaa"
}

variable "instancetype" {
  default = "t3.medium"
}

variable "vpc_name" {
  default = "dotun_vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "az1" {
  default = "eu-west-2a"
}

variable "az2" {
  default = "eu-west-2b"
}

variable "priv_subnet1" {
  default = "10.0.1.0/24"
}

variable "priv_subnet2" {
  default = "10.0.2.0/24"
}

variable "pub_subnet1" {
  default = "10.0.3.0/24"
}

variable "pub_subnet2" {
  default = "10.0.4.0/24"
}

variable "key" {
  default = "lofty"
}

variable "docker_name" {
  default = "Docker-Server"
}