#creating Load Balancer
resource "aws_lb" "dotun-ALB" {
  name               = "${var.name}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ALB_security]
  subnets            = [var.ALB-subnet1, var.ALB-subnet2]
  enable_deletion_protection = false
  tags = {
    Environment = var.env
  }
}
#creating Load balancer Target Group                                    
resource "aws_lb_target_group" "dotun-ALB-TG" {
  name     = "${var.name}-ALB-TG"
  target_type = "instance"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_name
  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 4
    interval = 45
  }
}
#Create Load balancer Listener
resource "aws_lb_listener" "dotun-ALB-listener" {
  load_balancer_arn = aws_lb.dotun-ALB.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dotun-ALB-TG.arn
  }
}

#creating Load balancer Target Group Attachment
resource "aws_lb_target_group_attachment" "dotun-ALB-TG-atch" {
  target_group_arn = aws_lb_target_group.dotun-ALB-TG.arn
  target_id        = var.Target_EC2
  port             = 8080
}