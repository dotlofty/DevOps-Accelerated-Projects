# Create ASG
resource "aws_autoscaling_group" "dotun_ASG" {
name = "${var.name}-asg"
max_size = 4
min_size = 2
desired_capacity = 3
health_check_grace_period = 300
health_check_type  = "EC2"
force_delete = true
launch_configuration = aws_launch_configuration.dotun_launch_config.id
vpc_zone_identifier  = [var.vpc-subnet1, var.vpc-subnet2]
target_group_arns = [var.albtg-arn]
tag{
    key = "Name"
    value = "docker_asg"
    propagate_at_launch = true
}
}

#Create ASG Policy
resource "aws_autoscaling_policy" "dotun_ASG_POLICY" {
name  = "${var.name}-asg-policy"
adjustment_type = "ChangeInCapacity"
policy_type = "TargetTrackingScaling"
autoscaling_group_name = aws_autoscaling_group.dotun_ASG.id
target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }    
}

#create ASG Launch Config
resource "aws_launch_configuration" "dotun_launch_config" {
  name          = "${var.name}-LaunchConfig"
  image_id      = aws_ami_from_instance.docker_ami_LC.id
  instance_type = var.LC-InstanceType
  associate_public_ip_address = true
  security_groups = [var.ASG-sg]
  key_name = var.key_pair
}

#create AMI from Instance
resource "aws_ami_from_instance" "docker_ami_LC" {
  name               = "${var.name}-dockerPROD_ami_LC"
  source_instance_id = var.dockerPROD_EC2
}
