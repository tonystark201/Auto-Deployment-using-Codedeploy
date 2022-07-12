
###################
# AWS Config
###################
variable "aws_region" {
  default     = "us-east-1"
  description = "aws region where our resources going to create choose"
}

variable "aws_access_key" {
  type = string
  description = "aws_access_key"
}

variable "aws_secret_key" {
  type = string
  description = "aws_secret_key"
}

###################
# Project Config
###################

variable "project_name" {
  description = "Project Name"
  default     = "DemoA"
}

variable "app_port" {
  description = "App port"
  default     = 80
}

variable "asg_min_size" {
  description = "The minimum size of the Auto Scaling Group."
  default     = 1
}

variable "asg_max_size" {
  description = "The maximum size of the Auto Scaling Group"
  default     = 3
}

variable "asg_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  default     = 2
}

variable "codedeploy_group_name" {
  description = "The name of codedeploy group name"
  default     = "dg_one"
}

variable "codedeploy_app_name" {
  description = "The name of codedeploy app name"
  default     = "demo_app"
}

variable "s3_key" {
  description = "The key of s3 object"
  default     = "deploy.zip"
}