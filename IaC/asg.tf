
###################
# ASG 
###################
resource "aws_autoscaling_group" "web_asg" {
  name                 = "web_asg"
  launch_configuration = aws_launch_configuration.web_launch_conf.name
  min_size             = var.asg_min_size
  desired_capacity     = var.asg_desired_capacity
  max_size             = var.asg_max_size
  health_check_type    = "EC2"
  target_group_arns = module.alb.target_group_arns
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier = module.vpc.public_subnets

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    module.alb
  ]

}

resource "aws_launch_configuration" "web_launch_conf" {
  name_prefix          = "devops-"
  image_id             = data.aws_ami.ubuntu.id
  iam_instance_profile = aws_iam_instance_profile.ec2_cd_instance_profile.name
  instance_type               = "t2.micro"
  security_groups             = [module.asg_sg.security_group_id]
  associate_public_ip_address = true

  user_data = file("codedeploy_agent_install.sh")

  lifecycle {
    create_before_destroy = true
  }
}


###################
# ASG Scale-up Policy
###################
resource "aws_autoscaling_policy" "web_asg_policy_up" {
  name                   = "web_asg_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_cloudwatch_metric_alarm" "web_asg_cpu_alarm_up" {
  alarm_name          = "web_asg_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = ["${aws_autoscaling_policy.web_asg_policy_up.arn}"]
}


###################
# ASG Scale-down Policy
###################
resource "aws_autoscaling_policy" "web_asg_policy_down" {
  name                   = "web_asg_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_cloudwatch_metric_alarm" "web_asg_cpu_alarm_down" {
  alarm_name          = "web_asg_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_asg_policy_down.arn]
}