
resource "aws_codedeploy_app" "demo_app" {
  name             = var.codedeploy_app_name
  compute_platform = "Server"
}

resource "aws_sns_topic" "demo_sns_topic" {
  name = "demo_sns_topic"
}

resource "aws_codedeploy_deployment_config" "demo_config" {
  deployment_config_name = "CodeDeployDefault2.EC2AllAtOnce"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 0
  }
}

resource "aws_codedeploy_deployment_group" "dg_one" {
  app_name              = aws_codedeploy_app.demo_app.name
  deployment_group_name = var.codedeploy_group_name
  service_role_arn      = aws_iam_role.codedeploy_role.arn


  trigger_configuration {
    trigger_events = [
      "DeploymentFailure", 
      "DeploymentSuccess",
      "DeploymentFailure", 
      "DeploymentStop",
      "InstanceStart", 
      "InstanceSuccess",
      "InstanceFailure"
     ]
    trigger_name       = "event-trigger"
    trigger_target_arn = aws_sns_topic.demo_sns_topic.arn
  }

  auto_rollback_configuration {
    enabled = false
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = ["my-alarm-name"]
    enabled = true
  }

  load_balancer_info {
    target_group_info {
      name = module.alb.target_group_names[0]
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  autoscaling_groups = [aws_autoscaling_group.web_asg.id]
}