variable "name" {
  default = "dotun"
  description = "The name associated with all resources for the Project"
}

variable "dotunvpc_id" {
  default = "dummy"
}

variable "ssh_port" {
  default = "22"
  description = "this port allows ssh access"
}

variable "http_port" {
  default = "80"
  description = "this port allows http access"
}

variable "all_access" {
  default = "0.0.0.0/0"
}

variable "proxy_port1" {
  default = "8080"
  description = "this port allows proxy access"
}

variable "proxy_port2" {
  default = "9000"
  description = "this port allows proxy access"
}

variable "mySQL_port" {
  default = "3306"
  description = "this port allows proxy access"
}