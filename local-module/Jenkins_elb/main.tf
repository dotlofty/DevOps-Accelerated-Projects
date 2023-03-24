# Create a jenkins elb
resource "aws_elb" "jenkins_elb" {
  name               = var.jenkins_elb_name
  subnets = [ var.subnet_id1, var.subnet_id2 ]
  security_groups = [ var.security_id ]


  listener {
    instance_port     = var.instance_prt
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 30
  }

  instances                   = [var.jenkins_id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = var.jenkins_elb_name
  }
}